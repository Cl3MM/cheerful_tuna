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
  #tire.search(load: true, size: 100) do

  def self.search(params)
    tire.search(load: true, page: params[:page], per_page: 50) do
      if params[:query].present?
        query { string params[:query] }
      else
        query { all }
      end
      #filter :range, published_at: {lte: Time.zone.now}
      #sort { by :company, "desc" }# if params[:query].blank?
    end
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
