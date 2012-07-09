class Member < ActiveRecord::Base
  attr_accessible :activity, :address, :billing_address,
    :billing_city, :billing_country, :billing_postal_code, :category,
    :city, :company, :country, :postal_code, :vat_number,
    :logo_file, :membership_file, :start_date

  has_many :contacts, :inverse_of => :contact
  accepts_nested_attributes_for :contacts

  mount_uploader :logo_file, MemberFilesUploader
  mount_uploader :membership_file, MemberFilesUploader
end
