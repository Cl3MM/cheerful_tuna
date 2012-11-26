#encoding: utf-8
class CollectionPoint < ActiveRecord::Base
  attr_accessible         :address, :city, :country,
                          :cp_id, :name, :postal_code,
                          :telephone, :contact_ids,
                          :status
  attr_reader             :full_address

  geocoded_by             :full_address
  paginates_per 25

  has_and_belongs_to_many :contacts

  validates :name,        presence: true
  validates :cp_id,       presence: true
  validates :postal_code, presence: true
  validates :city,        presence: true
  validates :country,     presence: true
  validates :address,     presence: true

  after_validation :geocode,
    if: lambda{ |obj| obj.address_changed? }

  def full_address
    "#{address}, #{postal_code} #{country.upcase}"
  end

end
