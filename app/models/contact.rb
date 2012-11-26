#encoding: utf-8
class Contact < ActiveRecord::Base

  WWW_PATERN  = /\b[http:\/\/]?([a-z0-9\._%-]+\.[a-z]{2,4})\b/i

  include Tire::Model::Search
  include Tire::Model::Callbacks

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
    :member_id, :tag_list, :city, :civility

  attr_reader :to_label, :to_select2, :full_name

  # before/after actions
  before_save :clean_up_attributes, :check_company_and_country, :validate_emails
  after_touch() { tire.update_index }

  # validations
  validates_presence_of :company, :country
  validates :company, uniqueness: {scope: [:country, :last_name, :address], message: " already exists with similar country, last name and address."}

  validates :civility, inclusion: { in: %w[Undef Mr Mrs Ms Dr], message: "%{value} is not a valid category" }

  # scopes
  scope :active_contacts, where(is_active: true)
  scope :inactive_contacts, where(is_active: false)
  scope :countries, select(:country).uniq
  scope :countries_1, { :select => :country, :group => :country }

  scope :contacts_group_by_user, joins(:user).group("users.username")

  scope :per_month, lambda { |date|  group('date(created_at)')
        .where(created_at: date.beginning_of_month..date.end_of_month)
  }

  def self.create_collection_point
    cp_attrs = [ :cp_id, :name, :telephone, :address, :postal_code, :city,
              :country, :contact_name, :contact_email, :contact_telephone ]
    cps = [ ["FR0002", "Trialp", "+33 4 79 96 41 05", "928 avenue de la houille blanche", "73000", "Chambéry", "France", "", "", ""],
      ["FR0002", "Gensun (Montpellier)", "+33805 23 33 23", "300 rue Rolland Garos, Espace Fréjorgues Ouest", "34130", "Maugio", "France", "", "", ""],
      ["FR0003", "Gensun (Aix en Provence)", "+33805 23 33 23", "Welcome Park - Bât B – Lot N°6, 505 rue Victor Baltard", "13854 ", "Aix-en-Provence", "France", "", "", ""],
      ["FR0005", "Gensun (Pau)", "+33805 23 33 23", "Rue des Bruyères, ZI de Berlanne", "64160", "Morlaas", "France", "", "", ""],
      ["BE0001", "MDU Construction", "+32497219937", "7 rue de la Science", "4530", "Villers-le-Bouillet", "Belgium", "Geoffrey MENTION", "geof@m-duconstruction.be", ""],
      ["SP0002", "Solucciona Energia", "+34699244937", "25 Calle Mayor", "28721", "Redueña", "Spain", "Manuel Camero", "mcamero@solucciona.com", "+34 699244937"],
      ["FR0002", "Gensun (Montpellier)", "+33805 23 33 23", "300 rue Rolland Garos, Espace Fréjorgues Ouest", "34130", "Maugio", "France", "", "", ""],
      ["FR0003", "Gensun (Aix en Provence)", "+33805 23 33 23", "Welcome Park - Bât B – Lot N°6, 505 rue Victor Baltard", "13854 ", "Aix-en-Provence", "France", "", "", ""],
      ["FR0005", "Gensun (Pau)", "+33805 23 33 23", "Rue des Bruyères, ZI de Berlanne", "64160", "Morlaas", "France", "", "", ""],
      ["FR0004", "Gensun (Toulouse)", "+33805 23 33 23", "Z.A.C des Marots, 36 chemin des Sévennes", "31770", "Colomiers", "France", "", "", ""],
      ["FR0006", "Gensun (Lille)", "+33805 23 33 23", "30 avenue de la libération", "59270", "Bailleul", "France", "", "", ""],
      ["DE0001", "SolarBau Süd GmbH", "+49 7022 24 440 - 0", "Lessingstraße 25", "D- 72663", "Großbettlingen", "Germany", "", "", ""],
      ["GR0001", "Silcio S.A.", "+30 2610 242001", "Industrial Area of Patras, Block 35D", "GR-265 00", "Patras", "Greece", "Nikos Papadellis", "n.papadellis@silcio.gr", ""],
      ["SP0001", "Solucciona Energia", "+34918135169", "Júpiter 16 ", "28229", "Villanueva del Pardillo", "Spain", "Fernando Mateo", "fmateo@solucciona.com", "+34 918 135 169"]
    ]
    cps.each do |cp|
      # mapping collection_point attr
      hash = cp.reduce({}) do |h, cpp|
        h[ cp_attrs[cp.find_index(cpp)] ] = ( cpp.strip.blank? ? nil : cpp.strip.gsub(/[\t\n]+|  +/," ").gsub(/  /, " "))
        h
      end
      #ap hash
      if CollectionPoint.where(hash.except(:contact_name, :contact_email, :contact_telephone)).empty? 
        puts "Creating Collection Point #{hash[:name]}"
        if hash[:contact_name]
          puts "Contact key found, creating or finding one"
          puts "Contact.where(company: \"#{hash[:name]}\", first_name: \"#{hash[:contact_name].split(' ').first}\", last_name: \"#{hash[:contact_name].split(' ').last}\", address: \"#{hash[:address]}\", city: \"#{hash[:city]}\")"

          # creating contact if exists
          contact = nil
          if ( Contact.where( company:        hash[:name],
                                      first_name:     hash[:contact_name].split(' ').first,
                                      last_name:      hash[:contact_name].split(' ').last,
                                      address:        hash[:address],
                                      city:           hash[:city]
            ).any? )
            contact = Contact.where( company:        hash[:name],
                                      first_name:     hash[:contact_name].split(' ').first,
                                      last_name:      hash[:contact_name].split(' ').last,
                                      address:        hash[:address],
                                      city:           hash[:city]
            ).first
            puts "Contact already exists"
          else
            puts "Contact does not exist, creating it..."
            contact = Contact.new(
              first_name:     hash[:contact_name].split(' ').first,
              last_name:      hash[:contact_name].split(' ').last,
              phone:          hash[:contact_telephone],
              city:           hash[:city],
              address:        hash[:address],
              postal_code:    hash[:postal_code],
              country:        hash[:country],
              company:        hash[:name],
              civility:       "Mr",
              category:       "Collection Point"
            )


            contact.emails.new(address: hash[:contact_email])
            contact.tag_list = "Collection Point"
            contact.update_attribute(:user_id, 1)
            contact.save!
          end
          contact
        else
          puts "Contactless collection point"
        end
        puts "Creating Collection Point"
        new_cp = hash.except(:contact_name, :contact_email, :contact_telephone)
        new_cp[:status] = "operational"

        collection_point = CollectionPoint.new(new_cp)
        collection_point.contact_ids = [contact.id] if contact
        collection_point.save
      else
        puts "Collection Point already exists: #{hash[:name]}"
      end
    end
  end

  ## Tire configuration for easier testing
  index_name("#{Rails.env}-#{Rails.application.class.to_s.downcase}-contacts")
  class << self

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

    def create_search_index
      search_index.delete
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
                emails:           { type: :string }
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

  def previous_contact
    Contact.where(["company < ?", self.company]).order("company DESC").first
  end

  def next_contact
    Contact.where(["company > ?", self.company]).order("company ASC").first
  end

  def to_indexed_json
    #to_json(methods: [:email_addresses])
    to_json(
      only: [:id, :address, :city, :first_name, :last_name, :company, :country, :category],
      include: [
        emails: { only: [ :address ] } ]
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
