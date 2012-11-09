class DeliveryRequest < ActiveRecord::Base

  attr_accessible :CIGS, :CdTe, :address, :amorphous_micromorph_silicon, :city,
    :concentration_PV, :comments, :company, :country, :crystalline_silicon, :email, :height, :ip,
    :laminates_flexible_modules, :latitude, :length, :longitude, :manufacturers,
    :modules_condition, :name, :postal_code, :reason_of_disposal, :referer, :serial_numbers,
    :telephone, :ua, :weight, :witdh

  validate :name, presence: true
  validate :email, presence: true
  validate :address, presence: true
  validate :postal_code, presence: true
  validate :city, presence: true
  validate :country, presence: true
  validate :reason_of_disposal, presence: true
  validate :country, presence: true

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
