class Contact < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks

  WWW_PATERN  = /\b[http:\/\/]?([a-z0-9\._%-]+\.[a-z]{2,4})\b/i

  versioned #:dependent => :tracking
  has_many :emails, :inverse_of => :contact, :dependent => :destroy
  belongs_to :user

  accepts_nested_attributes_for :emails, allow_destroy: true, :reject_if => proc {|a| a["address"].blank?}

  attr_accessible :address, :category, :cell, :company, :country, :fax,
    :first_name, :infos, :is_active, :is_ceres_member, :last_name, :website,
    :position, :postal_code, :phone, :emails_attributes, :versions_attributes,
    :member_id

  #after_initialize :validate_emails
  #before_save :clean_up_attributes#, :validate_emails
  #before_save :validate_company
  #before_save :valide_country
  #before_validation :clean_data


  #before_validation :log_validate
  #before_save :log_save

  #def log something
    #Rails.logger.debug "*" *2 + something + "*" *20
  #end
  #def log_validate
    #log "Validation"
  #end
  #def log_save
    #log "save"
  #end

  validates_presence_of :company, :country
  validates :company, uniqueness: {scope: [:country, :last_name, :address], message: "A contact with similar company, country, last name and address already exists."}
  #validates_associated :emails

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
    indexes :first_name, type: 'string'
    indexes :last_name, type: 'string'
    indexes :company, type: 'multi_field', fields: {
                        company: { type: "string", index: "analyzed" },
                        untouched: { type: "string", index: "not_analyzed" }
                      }
    indexes :country, type: 'string'
    indexes :email_addresses
  end

  def self.search(params)
    tire.search(page: params[:page], per_page: 50) do
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
  #validate validate_contact_uniqness
  #def validate_contact_uniqness
    ##Hash[Contact.all.map{|c| [c.id,[c.company,c.country, c.address, c.website]]}]
    #errors[:base] << "C'est la merde"
    #errors.add(:emails, "Tututu")
  #end

  #def check_email
    #if email.blank?
      #validates :email, :presence => {:message => "Your email is used to save your greeting."}
    #else
      #validates :email,
        #:email => true,
        #:uniqueness => { :case_sensitive => false }      
    #end
  #end

  protected

  def validate_emails
    Rails.logger.debug "validate_emails "+"*" * 100
    Rails.logger.debug self.attributes
    emails_attributes.each do |email|
      errors[:base] << "#{email.address} already exists." if Email.find_by_address(email.address)
    end
  end

  def validates_associated_emails emails
    Rails.logger.debug "validates_associated_emails "+"*" * 100
    Rails.logger.debug emails
    emails.each do |email|
      Rails.logger.debug email
      if address.blank?
        self.errors[:base] << "Email address can't be blank."
      else
        self.errors[:base] << "#{email.address} already exists." if Email.find_by_address(email.address)
      end
    end
    Rails.logger.debug self.errors
  end

  #validate :country_cant_be_blank
  #def country_cant_be_blank
    #Rails.logger.debug "Country:  #{country}"
    #errors.add(:country, "You must select a country!") if country.blank?
  #end

  #before_validation :clean_data

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

end
