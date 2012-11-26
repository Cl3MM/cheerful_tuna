class DeliveryRequest < ActiveRecord::Base
  extend FriendlyId
  friendly_id :url_hash, use: :slugged

  #btQkqBq5K8JKQ
  attr_accessible :address, :city, :comments, :company, :country, :email, :height,
    :latitude, :length, :longitude, :manufacturers, :module_count, :modules_production_year,
    :modules_condition, :name, :pallets_number, :postal_code, :reason_of_disposal, :referer, :serial_numbers,
    :technology, :telephone, :user_agent, :user_ip, :weight, :width

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

  def options_for_reason_of_disposal
    DELIVERY_REQUESTS_REASON_OF_DISPOSAL
  end

  def options_for_modules_condition
    DELIVERY_REQUESTS_MODULES_CONDITION
  end

  def available_status
    DELIVERY_REQUESTS_STATUS
  end

  def send_confirmation_email
    DeliveryRequestMailer.send_confirmation_email(self).deliver
  end

  def available_technologies
    DELIVERY_REQUESTS_TECHNOLOGIES
  end

  def available_technologies_formatted
    DELIVERY_REQUESTS_TECHNOLOGIES.keys.each_slice(3).to_a
  end

  def url_hash
    "#{Digest::SHA1.hexdigest(self.id.to_s).gsub(/[0-9]/, '')}#{Digest::SHA1.hexdigest("#{self.id}#{self.created_at}")}"
  end
end
