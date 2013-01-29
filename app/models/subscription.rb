class Subscription < ActiveRecord::Base
  attr_accessible :current, :end_date, :cost, :owner_id, :paid, :start_date, :status

  belongs_to :owner, polymorphic: true, inverse_of: :subscriptions

  scope :current, where( current: true).limit(1)

end
