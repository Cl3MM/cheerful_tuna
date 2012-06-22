class Contact < ActiveRecord::Base
  attr_accessible :address, :category, :cell, :company, :country, :fax, :first_name, :infos, :is_active, :is_ceres_member, :last_name, :position, :postal_code, :telphone
end
