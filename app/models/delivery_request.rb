class DeliveryRequest < ActiveRecord::Base

  attr_accessible :CIGS, :CdTe, :address, :amorphous_micromorph_silicon, :city,
    :concentration_PV, :comments, :company, :country, :crystalline_silicon, :email, :height,
    :laminates_flexible_modules, :latitude, :length, :longitude, :manufacturers, :module_count,
    :modules_condition, :name, :pallets_number, :postal_code, :reason_of_disposal, :referer, :serial_numbers,
    :telephone, :user_agent, :user_ip, :weight, :witdh

  validates :name, presence: true
  validates :email, presence: true
  validates :address, presence: true
  validates :postal_code, presence: true
  validates :city, presence: true
  validates :country, presence: true
  validates :reason_of_disposal, presence: true
  validates :modules_condition, presence: true
  validates :country, presence: true

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
