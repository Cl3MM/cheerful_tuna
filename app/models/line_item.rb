class LineItem < ActiveRecord::Base
  attr_accessible :amount, :designation, :unit_price, :invoice_id
  belongs_to      :invoice, inverse_of: :line_items

  validates :designation, presence: true
  validates :amount,      numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price,  numericality: { greater_than: 0 }

  def total_price
    amount * unit_price
  end
end
