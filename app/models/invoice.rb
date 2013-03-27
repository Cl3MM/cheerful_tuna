class Invoice < ActiveRecord::Base
  paginates_per 25
  attr_accessible               :country, :designation, :line_items_attributes
  has_many                      :line_items, inverse_of: :invoice,
                                  dependent: :destroy
  accepts_nested_attributes_for :line_items, allow_destroy: true

  validates :designation, presence: true

  def total_price
    self.line_items.map(&:total_price).sum
  end

  def create_code
    code = generate_code
    update_attribute(:code, code)
  end

  def generate_code
    this_month_range = Date.current.beginning_of_month..Date.current.end_of_month
    monthly_invoices = Invoice.where(created_at: this_month_range).order('id ASC')
    code = if monthly_invoices.any?
      last_code = monthly_invoices.last.code.scan(/-(\d{4})$/).flatten.first.to_i
      last_code + 1
    else
      1
    end
    "#{Date.current.strftime("%y")}#{Date.current.strftime("%m")}-#{"%04d" % code}"
  end
end
