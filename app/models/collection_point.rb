class CollectionPoint < ActiveRecord::Base
  attr_accessible :address, :city, :country, :cp_id, :name, :postal_code, :telephone
  has_and_belongs_to_many :contacts
end
