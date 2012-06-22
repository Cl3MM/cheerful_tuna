class Contact < ActiveRecord::Base
  has_many :emails
  #belongs_to :country

  accepts_nested_attributes_for :emails, allow_destroy: true

  attr_accessible :address, :category, :cell, :company, :country, :fax,
    :first_name, :infos, :is_active, :is_ceres_member, :last_name,
    :position, :postal_code, :telphone, :emails_attributes

end
