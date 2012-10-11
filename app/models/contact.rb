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
    :member_id, :tag_list

  attr_reader :to_label, :to_select2

  def to_select2
    { id: self.id, text: self.to_label }
  end

  before_save :clean_up_attributes, :check_company_and_country, :validate_emails

  validates_presence_of :company, :country
  validates :company, uniqueness: {scope: [:country, :last_name, :address], message: " already exists with similar country, last name and address."}

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
    Rails.logger.debug "Params dans Search: #{params}"
    tire.search(page: params[:page], per_page: 50) do
      if params[:query].present?
        Rails.logger.debug "Query #{params[:query]} <=" + "*"* 100
        query { string params[:query] }
      else
        Rails.logger.debug "Query ALL <=" + "*"* 100
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
    name = [self.first_name, self.last_name].delete_if{|x| x.blank? }
    render = " (#{name.map(&:capitalize).join(" ") })" if name.size > 0
    "#{self.company}#{render if name.size > 0}"
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
