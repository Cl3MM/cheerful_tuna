class DeliveryRequest < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper #To enable the use of number_to_human
  extend FriendlyId
  belongs_to          :collection_point, :inverse_of => :delivery_requests, touch: true
  friendly_id         :url_hash, use: :slugged
  geocoded_by         :full_address

  #btQkqBq5K8JKQ
  attr_accessible :address, :city, :collection_point_id, :comments, :company, :country, :email, :height,
    :latitude, :length, :longitude, :manufacturers, :module_count, :modules_production_year,
    :modules_condition, :name, :pallets_number, :postal_code, :reason_of_disposal, :referer, :serial_numbers,
    :status, :technology, :telephone, :user_agent, :user_ip, :weight, :width

  validates :name,                    presence: true
  validates :email,                   presence: true
  validates :manufacturers,           presence: true
  validates :address,                 presence: true
  validates :postal_code,             presence: true
  validates :city,                    presence: true
  validates :country,                 presence: true
  validates :reason_of_disposal,      presence: true
  validates :modules_condition,       presence: true
  validates :module_count,            presence: true, numericality: { :greater_than => 0 }
  validates :modules_production_year, presence: true, numericality: { :greater_than => 0 }
  validates :length,                  presence: true, numericality: { :greater_than => 0 }
  validates :width,                   presence: true, numericality: { :greater_than => 0 }
  validates :height,                  presence: true, numericality: { :greater_than => 0 }
  validates :weight,                  presence: true, numericality: { :greater_than => 0 }
  validates :pallets_number,          presence: true, numericality: { :greater_than => 0 }

  after_validation :geocode,
    if: lambda{ |obj| obj.address_changed? }#,
    #unless: Rails.env.test?

  def full_address
    "#{address}, #{postal_code} #{city}, #{country.upcase}"
  end

  def self.delivery_requests_reason_of_disposal
    DELIVERY_REQUESTS_REASON_OF_DISPOSAL
  end

  def self.delivery_requests_modules_condition
    DELIVERY_REQUESTS_MODULES_CONDITION
  end

  def available_status
    DELIVERY_REQUESTS_STATUS
  end

  def send_confirmation_email
    DeliveryRequestMailer.send_confirmation_email(self).deliver
  end

  def humanized_delivery_requests_technologies
    DELIVERY_REQUESTS_TECHNOLOGIES[self.technology]
  end

  def self.delivery_requests_technologies
    DELIVERY_REQUESTS_TECHNOLOGIES
  end

  def collection_point_placeholder
    cpoint = self.collection_point
    return cpoint.collection_point_to_select2(cpoint.distance_to_human(self)).to_json if self.collection_point_id?
    #return { id: cpoint.id, text: cpoint.nearest_to_json(cpoint.distance_to_human(self)) }.to_json if self.collection_point_id?
    { id: -1, text: "No Collection Point associated"}.to_json
  end

  def self.collection_points_nearbys params
    delivery_location = Hash.new
    if params[:a].present?  and delivery_location[:address]     = params[:a] and
       params[:c].present?  and delivery_location[:city]        = params[:c] and
       params[:p].present?  and delivery_location[:postal_code] = params[:p] and
       params[:co].present? and delivery_location[:country]     = params[:co]

      delivery_location_address = "#{delivery_location[:address]}, #{delivery_location[:postal_code]} #{delivery_location[:city]}, #{delivery_location[:country].upcase}"
      locations = CollectionPoint.near_delivery_location delivery_location
      locations.to_json
    else
      { json: { error: "Wrong params" }, status: :unprocessable_entity }
    end
  end

  def self.delivery_requests_technologies_formatted
    self.delivery_requests_technologies.keys.each_slice(3).to_a
  end

  def url_hash
    "#{Digest::SHA1.hexdigest(self.id.to_s).gsub(/[0-9]/, '')}#{Digest::SHA1.hexdigest("#{self.id}#{self.created_at}")}"
  end

  def self.delivery_requests_status
    DELIVERY_REQUESTS_STATUS
  end

  def delivery_requests_status
    DELIVERY_REQUESTS_STATUS
  end

  def status_html_class
    index = delivery_requests_status.keys.find_index self.status.to_sym
    size  = delivery_requests_status.keys.size
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
    delivery_requests_status[self.status]
  end

end
