#require 'ostruct'

class CostsComparison < OpenStruct
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming
  include ActiveRecord::Callbacks

  InitValues =  { megawatts: 15, operating_countries: 27 }

  ContributionFeeCERES    = 1
  ContributionFeePVCYCLE  = 1.65

  MinimumFeeCERES         = 1500
  MinimumFeePVCYCLE       = 150

  validates :megawatts,     :operating_countries, presence: true
  validates :megawatts,     numericality: { only_integer: true, greater_than: 0 }

  validates :operating_countries, numericality: { only_integer: true, greater_than: 0, less_than: 28 }

  attr_accessor :megawatts,
                :operating_countries,
                :tons_of_modules

  #after_validation :convert_to_integer

  def initialize(attributes = InitValues)
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def ceres_contribution_fee_per_ton
    ContributionFeeCERES
  end

  def pvcycle_contribution_fee_per_ton
    ContributionFeePVCYCLE
  end

  def convert_to_integer
    @megawatts            = @megawatts.to_i
    @tons_of_modules      = @megawatts * 100
    @operating_countries  = @operating_countries.to_i
  end
  #validates_length_of :content, :maximum => 500

  def pvcycle_total_fees
    pvcycle_membership_fee + pvcycle_contribution_fee
  end

  def pvcycle_contribution_fee
    #=IF(D6*B11<D4*B13;D4*B13;D6*B11)
    ( pvcycle_max_contribution < pvcycle_max_minimal_fee ) ? pvcycle_max_minimal_fee : pvcycle_max_contribution
  end

  def pvcycle_max_minimal_fee
    @operating_countries * MinimumFeePVCYCLE
  end

  def pvcycle_max_contribution
    @tons_of_modules * ContributionFeePVCYCLE
  end

  def pvcycle_membership_fee
    @operating_countries > 5 ? 1250 : @operating_countries * 250
  end

  def ceres_max_contribution
    @tons_of_modules * ContributionFeeCERES
  end

  def ceres_contribution_fee
    #=IF(D6*D11<1500;1500;D6*D11)
    ceres_max_contribution < MinimumFeeCERES ? MinimumFeeCERES : ceres_max_contribution
  end

  def ceres_membership_fee
    500
  end

  def ceres_total_fees
    ceres_membership_fee + ceres_contribution_fee
  end

  def difference
    pvcycle_total_fees - ceres_total_fees
  end

  def difference_percent
    (1.0 - (ceres_total_fees / pvcycle_total_fees.to_f) ) * 100
  end
  def pvcycle_total_css_class
    ceres_total_css_class == "badge-important" ? "badge-success" : "badge-important"
  end

  def ceres_total_css_class
    ceres_total_fees > pvcycle_total_fees ? "badge-important" : "badge-success"
  end

  def ceres_minimum_fee
    MinimumFeeCERES
  end
  def pvcycle_minimum_fee
    MinimumFeePVCYCLE
  end

  def persisted? ; false ; end
end
