class DeliveryRequest < ActiveRecord::Base

  attr_accessible :CIGS, :CdTe, :address, :amorphous_micromorph_silicon, :city,
    :concentration_PV, :comments, :company, :country, :crystalline_silicon, :email, :height,
    :laminates_flexible_modules, :latitude, :length, :longitude, :manufacturers, :module_count,
    :modules_condition, :name, :pallets_number, :postal_code, :reason_of_disposal, :referer, :serial_numbers,
    :telephone, :user_agent, :user_ip, :weight, :width

  validates :name, presence: true
  validates :email, presence: true
  validates :address, presence: true
  validates :postal_code, presence: true
  validates :city, presence: true
  validates :country, presence: true
  validates :reason_of_disposal, presence: true
  validates :module_count, presence: true, numericality: { :greater_than => 0 }
  validates :modules_condition, presence: true
  validates :length, presence: true, numericality: { :greater_than => 0 }
  validates :width, presence: true, numericality: { :greater_than => 0 }
  validates :height, presence: true, numericality: { :greater_than => 0 }
  validates :weight, presence: true, numericality: { :greater_than => 0 }
  validates :pallets_number, presence: true, numericality: { :greater_than => 0 }

  def options_for_reason_of_disposal
    [
      "End of use",
      "Transport or installation damage",
      "Material defect",
      "Other"
    ]
  end

  def options_for_modules_condition
    [
      "Intact",
      "In pieces or pieces removed",
      "Broken", "Heat point", "Delaminated",
      "Other"
    ]
  end
end
