#encoding: utf-8
class CollectionPoint < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper #To enable the use of number_to_human
  attr_accessible         :address, :city, :country,
                          :cp_id, :name, :postal_code,
                          :telephone, :contact_ids,
                          :status
  attr_reader             :full_address

  geocoded_by             :full_address
  paginates_per 25

  has_and_belongs_to_many :contacts
  has_many :delivery_requests, :inverse_of => :collection_point

  validates :name,        presence: true
  validates :cp_id,       presence: true
  validates :postal_code, presence: true
  validates :city,        presence: true
  validates :country,     presence: true
  validates :address,     presence: true

  after_validation :geocode,
    if: lambda{ |obj| obj.address_changed? },
    unless: Rails.env.test?

  def create_collection_point_tag_on_contacts
    contacts.each do |contact|
      member_tags = contact.tag_list
      unless member_tags.include? "collection point"
        puts "Creating Tag"
        member_tags << "collection point"
        contact.tag_list = member_tags.join(",")
        contact.save
      end
    end
  end

  def collection_point_to_select2 distance
      #self.nearest_to_json(distance),
      {
        id:       self.id,
        text:     self.nearest_to_json(distance),
        name:     self.name,
        address:  self.address,
        city:     self.city,
        zip:      self.postal_code,
        country:  self.country,
        distance: distance
      }
  end
  def self.near_delivery_location delivery_location
    delivery_location_address = "#{delivery_location[:address]}, #{delivery_location[:postal_code]} #{delivery_location[:city]}, #{delivery_location[:country].upcase}"
    near(delivery_location_address, 400, order: :distance).where(country: delivery_location[:country]).limit(3).map do |c|
      distance = c.distance_to_human(delivery_location_address)
      c.collection_point_to_select2(distance)
    end
  end

  def nearest_to_json distance
    "<div class='collection_point_name' style='padding: 3px 7px; background-color: #F2F2F2; width: 100%;'> \
<span style='width: 80%;'> \
<b>#{self.name}</b>\
<span style='float: right; margin-right: 16px;'>#{distance}</span>\
</span>\
</div>\
<div style='margin-bottom: 1px; padding: 2px 7px;'>\
#{self.address}<br/>#{self.postal_code}, #{self.city}\
</div>"
  end

  def distance_to_human(*args)
    @calculate_distance_to ||= {}
    @calculate_distance_to[args] ||= calculate_distance_to(*args)
  end

  def full_address_block
    "#{address},<br/>#{postal_code} #{city},<br/> #{country.upcase}"
  end

  def full_address
    "#{address}, #{postal_code} #{city}, #{country.upcase}"
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
    debug  [ collection_points_status.keys.inspect, self.status.to_sym.inspect, collection_points_status.keys.find_index(self.status.to_sym).inspect ]
    index = collection_points_status.keys.find_index self.status.to_sym
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

  private

  def calculate_distance_to location
    Rails.logger.debug "=" * 100
    Rails.logger.debug "location: #{location}"
    begin
      number_to_human( distance_to(location, :km) * 1000, units: :distance )
    rescue => e
      Rails.logger.debug "[ERROR][a/m/collection_point.rb][calculate.distance.to:line:112]:\n#{e.backtrace.join('\n')}"
      "Error, please reload"
    end
  end

end
