class Member < ActiveRecord::Base
  attr_accessible :activity, :address, :billing_address, :billing_city, :billing_country, :billing_postal_code, :category, :city, :company, :country, :postal_code, :vat_number
end
