class Contact < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks


  WWW_PATERN  = /\b[http:\/\/]?([a-z0-9\._%-]+\.[a-z]{2,4})\b/i

  versioned :dependent => :tracking
  has_many :emails, :inverse_of => :contact
  belongs_to :user

  accepts_nested_attributes_for :emails, allow_destroy: true #, :reject_if => proc {|a| a["address"].blank?}

  attr_accessible :address, :category, :cell, :company, :country, :fax,
    :first_name, :infos, :is_active, :is_ceres_member, :last_name, :website,
    :position, :postal_code, :phone, :emails_attributes, :versions_attributes

  validates_associated :emails
  validates_presence_of :company, :country

  before_validation :clean_up_attributes
  scope :countries, { :select => :country, :group => :country }

  def clean_up_attributes
    attributes.each_pair do |k, v|
      if v.class == String and not v.nil?
        x = v.gsub(/\n/, " ")
        x.gsub!(/  +/, " ") unless x.nil?
        x.strip! unless x.nil?
        x.capitalize! if k == "company"
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
  #scope :limit, lambda { |num| { :limit => num } }
  #validate :something
  #@contacts = Contact.order(:company).page(params[:page]).per(15) #search(params)#.page(params[:page]).per(5)
  #tire.search(load: true, size: 100) do

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

  def validate_contact_uniqness
    Hash[Contact.all.map{|c| [c.id,[c.company,c.country, c.address, c.website]]}]
    if Contact.all.map()
      errors[:base] << "C'est la merde"
      errors.add(:emails, "Tututu")
    end
  end
  #def self.paginate(options = {})
    #page(options[:page]).per(options[:per_page])
  #end

end
