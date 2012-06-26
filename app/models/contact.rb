class Contact < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks

  versioned :dependent => :tracking
  has_many :emails
  belongs_to :user

  accepts_nested_attributes_for :emails, allow_destroy: true #, :reject_if => proc {|a| a["address"].blank?}

  attr_accessible :address, :category, :cell, :company, :country, :fax,
    :first_name, :infos, :is_active, :is_ceres_member, :last_name, :website,
    :position, :postal_code, :phone, :emails_attributes, :versions_attributes

  validates_associated :emails
  validates_presence_of :company, :country

  #scope :limit, lambda { |num| { :limit => num } }
  #validate :something
  #@contacts = Contact.order(:company).page(params[:page]).per(15) #search(params)#.page(params[:page]).per(5)

  def self.search(params)
    tire.search(load: true,  page: params[:page], per_page: 50) do
      query { string params[:query], default_operator: "AND" } if params[:query].present?
      sort { by :company, "asc" } if params[:query].blank?
    end
  end

  def something
    Rails.logger.debug(self)
    errors[:base] << "C'est la merde"
    errors.add(:emails, "Tututu")
  end

  def self.paginate(options = {})
    page(options[:page]).per(5)
  end
end
