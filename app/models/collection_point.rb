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

  def lat_long
    if self.latitude.blank? or longitude.blank?
      "Invalid Geolocation."
    else
      "lat: #{self.latitude} / long: #{self.longitude}"
    end
  end

  def self.collection_points_status
    COLLECTION_POINTS_STATUS
  end

  def collection_points_status
    COLLECTION_POINTS_STATUS
  end

  def status_html_class
    index = collection_points_status.keys.find_index self.status
    size  = collection_points_status.keys.size
    if index < (size * 0.25)
      "text-error"
    elsif index < (size * 0.50)
      "text-warning"
    elsif index < (size * 0.75)
      "text-info"
    else
      "text-success"
    end
  end

  def humanized_status
    collection_points_status[self.status]
  end
end
