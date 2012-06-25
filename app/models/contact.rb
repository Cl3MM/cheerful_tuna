class Contact < ActiveRecord::Base
  has_many :emails
  #belongs_to :country

  accepts_nested_attributes_for :emails, allow_destroy: true #, :reject_if => proc {|a| a["address"].blank?}

  attr_accessible :address, :category, :cell, :company, :country, :fax,
    :first_name, :infos, :is_active, :is_ceres_member, :last_name, :website,
    :position, :postal_code, :telphone, :emails_attributes

  validates_associated :emails
  validates_presence_of :company, :country

  #validate :something

  def something
    Rails.logger.debug(self)
    errors[:base] << "C'est la merde"
    errors.add(:emails, "Tututu")
  end

end
