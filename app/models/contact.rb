#encoding: utf-8
class Contact < ActiveRecord::Base

  WWW_PATERN  = /\b[http:\/\/]?([a-z0-9\._%-]+\.[a-z]{2,4})\b/i

  include Tire::Model::Search
  include Tire::Model::Callbacks
  include Scrollable

  Tire::Results::Collection.module_eval do
    def to_ary
      self.to_a
    end
  end if Rails.env.test?


  paginates_per 25
  acts_as_taggable
  versioned #:dependent => :tracking

  # Associations
  has_many :emails, :inverse_of => :contact, :dependent => :destroy
  has_and_belongs_to_many :members
  has_and_belongs_to_many :collection_points
  belongs_to :user

  accepts_nested_attributes_for :emails, allow_destroy: true#, :reject_if => proc {|a| a["address"].blank?}

  # Attributes accessibles
  attr_accessible :address, :category, :cell, :company, :country, :fax,
    :first_name, :infos, :is_active, :is_ceres_member, :last_name, :website,
    :position, :postal_code, :phone, :emails_attributes, :versions_attributes,
    :tag_list, :city, :civility

  attr_reader :to_label, :to_select2, :full_name

  # before/after actions
  before_save :clean_up_attributes, :check_company_and_country, :validate_emails
  after_touch() { tire.update_index }

  # validations
  validates_presence_of :company, :country
  validates :company, uniqueness: {scope: [:country, :last_name, :address], message: " already exists with similar country, last name and address."}

  validates :civility, inclusion: { in: %w(Undef Mr Mrs Ms Dr), message: "%{value} is not a valid category" }

  # scopes
  scope :active_contacts, where(is_active: true)
  scope :inactive_contacts, where(is_active: false)
  scope :countries, select(:country).uniq
  scope :countries_1, { :select => :country, :group => :country }

  scope :contacts_group_by_user, joins(:user).group("users.username")

  scope :per_month, lambda { |date|  group('date(created_at)')
        .where(created_at: date.beginning_of_month..date.end_of_month)
  }

  ## Tire configuration for easier testing
  index_name("#{Rails.env}-#{Rails.application.class.to_s.downcase}-contacts")
  class << self

    # TODO:
    # Faire un scope qu'on peut chainer avec un autre scope sur les Pays
    #
    def email_addresses_tagged_for_mailing tags, countries = nil
      contacts = self.active_contacts
      contacts = contacts.where('contacts.country in (?)', countries) unless countries.nil? || countries.empty?
      contacts = contacts.tagged_with(tags.split(",")) unless tags.blank?
      contacts.nil? ? [] : contacts.joins(:emails).select('emails.address').order('emails.address ASC').map(&:address).sort.uniq
    end

    def search(params)
      per_page = (params[:ppage].present? ? (params[:ppage].to_i rescue 50) : 50 )
      tire.search(page: params[:page], per_page: per_page) do
        Rails.logger.debug "Params: #{params}"
        if params[:query].present?
          query { string params[:query] }
        else
          query { all }
        end
        #filter :range, published_at: {lte: Time.zone.now}
        sort { by "company.untouched", "asc" }# if params[:query].blank?
      end
    end

    def geolocate
      Contact.where('id BETWEEN ? and ?', 1, 10).each do |contact|
        puts "#{contact.id}:\n - old addr: #{contact.full_address}"
        geo_result = Geocoder.search(contact.full_address)
        if geo_result
          street_number = (geo_result.first.address_components_of_type(:street_number).first["long_name"] rescue nil)
          route = (geo_result.first.address_components_of_type(:route).first["long_name"] rescue nil)
          attrs = { city: geo_result.first.city,
                    postal_code: geo_result.first.postal_code,
                    country: geo_result.first.country,
                    address: ((street_number.nil? or route.nil?) ? contact.address : "#{street_number} #{route}")
          }
          ap attrs
          attrs = attrs.reduce({}) do |res, (k,s)|
            res[k] = s if s
            res
          end
          contact.update_attributes(attrs)
        end
        puts "- new addr: #{contact.full_address}"
      end
    end
    def rebuild_index
      Contact.delete_search_index
      Contact.create_search_index
      Contact.import_index
    end
    def create_search_index
      Tire.index Contact.index_name do
        create mappings: {
            contact: {
              properties: {
                id:               { type: :integer },
                name:             { type: :string  },
                address:          { type: :string  },
                city:             { type: :string  },
                first_name:       { type: :string  },
                last_name:        { type: :string  },
                company:          {
                  type: :multi_field,
                  fields: {
                    company:      { type: :string, index: :analyzed },
                    untouched:    { type: :string, index: :not_analyzed }
                  }
                },
                country:          { type: :string },
                emails:           { type: :string },
                tags_list:             { type: :string }
                #email_addresses:  { type: :string }
              }
            }
          }
      end
    end

    def import_index
      Tire.index Contact.index_name do
        import Contact.all
      end
      search_index.refresh
    end

    def delete_search_index
      search_index.delete
    end

    def search_index
      Tire.index(Contact.index_name)
    end
  end

  #def method_missing(meth, *args, &block)
    #if meth.to_s =~ /^(previous|next)_?(\w*)$/
      #action, attribute = $1, $2
      #return run_previous_method(attribute, *args, &block)  if action =~ /previous/
      #return run_next_method(attribute, *args, &block)      if action =~ /next/
      #nil
    #else
      #super
    #end
  #end

  ## run_next_method:
  ##     define_method for next, next_company, next_name...
  #def run_next_method(attrs, *args, &block)
    #puts "Attrs: #{attrs}"
    #puts "Attrs: #{attrs}"
    #if (not attrs.blank?) && (self.attribute_names.include?(attrs) )
      #return Contact.where( [ "#{attrs} > ?", self[attrs] ] ).first
    #else
      #return Contact.where(["id > ?", self.id]).first
    #end
  #end

  #def run_previous_method(attrs, *args, &block)
    #if (not attrs.blank?) && (self.attribute_names.include?(attrs) )
      #return Contact.where( [ "#{attrs} < ?", self[attrs] ] ).last
    #else
      #return Contact.where(["id < ?", self.id]).last
    #end
  #end

  def to_indexed_json
    #to_json(methods: [:email_addresses])
    to_json(
      only: [:id, :address, :city, :first_name, :last_name, :company, :country, :category],
      include: [
        emails: { only: [ :address ] }
        #tags:   { only: [ :name ] }
      ],
      methods: [ :tag_list ]
    )
  end

  def email_addresses
    emails.map(&:address)
  end

  # Generate Json format for select2
  def to_select2
    { id: self.id, text: self.to_label }
  end

  # Duplicate contact appending COPY at the end of the company field
  def duplicate
    copy_attributes = self.attributes.symbolize_keys.except(:id, :created_at, :updated_at, :user_id, :emails_attributes)
    copy_attributes[:company] = self.company + " (COPY)"
    copy_attributes
    new_contact = Contact.new(copy_attributes)
    return new_contact
  end

  def create_tags_from_category
    tag_category = CategoriesToTags.new
    tch = tag_category.tags_categories_hash
    Contact.all.each do |contact|
      c = contact.dup
      if tch.keys.include? c.category
        tch_tags    = tch[c.category]
        c.tag_list.add(tch_tags)
        c.delay_for(1.seconds).debug_job tch_tags.join(", ")
        c.delay_for(90.seconds).save
      end
    end
  end

  def debug_job tags
    Rails.logger.debug "contact id: #{:id} | tag_list: #{tags}"
  end

  def to_label
    "#{self.company}#{ " (" + self.full_name + ")" unless self.full_name.blank? }"
  end

  def full_name
    full_name = [(self.first_name.capitalize rescue nil), (self.last_name.upcase rescue nil)].delete_if{|x| x.gsub(/ +/, "").blank?}.compact.join(" ")
    full_name.blank? ? "Undefined" : full_name
  end

  def full_address
    puts "address :#{self.address}"
    puts "city :#{self.city}"
    puts "postal_code? :#{self.postal_code}"
    puts "country :#{self.country}"
    if (self.address.blank? or self.city.blank? or self.postal_code.blank? or self.country.blank?)
      return self.address
    else
      return "**************** PRETTY ADDRESS: #{self.address}, #{self.postal_code} #{self.city}, #{self.country}"
    end
  end

  protected

  def clean_up_attributes
    attributes.each_pair do |k, v|
      #next if ["country"].include? k
      if v.class == String and not v.nil?
        x = v.gsub(/\n/, " ")
        x.gsub!(/  +/, " ") unless x.nil?
        x.strip! unless x.nil?
        x.upcase! if k == "company"
        if k == "website"
          x = x.scan(WWW_PATERN).flatten.map{|w| "http://#{w}"}.join(";") if x.match(WWW_PATERN)
        end
        send("#{k}=", x)
      end
    end
  end

  def clean_data
    # trim whitespace from beginning and end of string attributes
    attribute_names.each do |name|
      if send(name).respond_to?(:strip)
        send("#{name}=", send(name).strip)
      end
    end
  end

  def check_company_and_country
    return false if self.company.blank? or self.country.blank?
  end

  def validate_emails
    valid = true
    if self.emails
      #valid = false if self.emails.first.address.blank?
      self.emails.each_with_index do |mail, index|
        valid = false if mail.address.blank?
        unless mail.address.match(/^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/i)
          valid = false
        end
      end
    else
      valid = false
    end

    unless valid
      self.errors.add(:base, "Email is invalid. Please check the format that should look similar to: xxxx.xxxx@xxx.xxx.xxx ")
    end
    return valid
  end

end
  #mapping do
    #indexes :id, type: 'integer'
    #indexes :address, type: 'string'
    #indexes :city, type: 'string'
    #indexes :first_name, type: 'string'
    #indexes :last_name, type: 'string'
    #indexes :company, type: 'multi_field', fields: {
                        #company: { type: "string", index: "analyzed" },
                        #untouched: { type: "string", index: "not_analyzed" }
                      #}
    #indexes :country, type: 'string'
    #indexes :email_addresses
  #end
