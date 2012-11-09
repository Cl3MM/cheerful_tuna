class Contact < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks

  acts_as_taggable
  versioned #:dependent => :tracking

  WWW_PATERN  = /\b[http:\/\/]?([a-z0-9\._%-]+\.[a-z]{2,4})\b/i

  has_many :emails, :inverse_of => :contact, :dependent => :destroy
  has_and_belongs_to_many :members
  belongs_to :user

  accepts_nested_attributes_for :emails, allow_destroy: true#, :reject_if => proc {|a| a["address"].blank?}

  attr_accessible :address, :category, :cell, :company, :country, :fax,
    :first_name, :infos, :is_active, :is_ceres_member, :last_name, :website,
    :position, :postal_code, :phone, :emails_attributes, :versions_attributes,
    :member_id, :tag_list, :city, :civility

  attr_reader :to_label, :to_select2, :full_name

  def to_select2
    { id: self.id, text: self.to_label }
  end

  before_save :clean_up_attributes, :check_company_and_country, :validate_emails

  validates_presence_of :company, :country
  validates :company, uniqueness: {scope: [:country, :last_name, :address], message: " already exists with similar country, last name and address."}

  validates :civility, inclusion: { in: %w[Undef Mr Mrs Ms Dr], message: "%{value} is not a valid category" }

  scope :active_contacts, where(is_active: true)
  scope :inactive_contacts, where(is_active: false)
  scope :countries, select(:country).uniq
  scope :countries_1, { :select => :country, :group => :country }

  scope :contacts_group_by_user, joins(:user).group("users.username")

  scope :per_month, lambda { |date|  group('date(created_at)')
        .where(created_at: date.beginning_of_month..date.end_of_month)
  }

  mapping do
    indexes :id, type: 'integer'
    indexes :address, type: 'string'
    indexes :city, type: 'string'
    indexes :first_name, type: 'string'
    indexes :last_name, type: 'string'
    indexes :company, type: 'multi_field', fields: {
                        company: { type: "string", index: "analyzed" },
                        untouched: { type: "string", index: "not_analyzed" }
                      }
    indexes :country, type: 'string'
    indexes :email_addresses
  end

  def previous_contact
    Contact.where(["company < ?", self.company]).order("company DESC").first
  end

  def next_contact
    Contact.where(["company > ?", self.company]).order("company ASC").first
  end

  def self.search(params)
    per_page = (params[:per_page].present? ? (params[:per_page].to_i rescue 50) : 50 )
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

  def to_indexed_json
    to_json(methods: [:email_addresses])
  end

  def email_addresses
    emails.map(&:address)
  end

  def duplicate
    copy_attributes = self.attributes
    copy_attributes.delete('id')
    copy_attributes.delete('created_at')
    copy_attributes.delete('updated_at')
    copy_attributes.delete('user_id')
    copy_attributes.delete('emails_attributes')
    copy_attributes[:company] = self.company + " (COPY)"
    new_contact = Contact.new(copy_attributes)
    return new_contact
  end

  def to_label
    "#{self.company}#{ " (" + self.full_name + ")" unless self.full_name.blank? }"
  end

  def self.geolocate
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
