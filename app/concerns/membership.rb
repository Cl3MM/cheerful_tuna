module Membership
  def self.included(base)
    base.attr_accessible :subscriptions_attributes
    base.has_many :subscriptions, as: :owner, dependent: :destroy, inverse_of: :owner
    base.accepts_nested_attributes_for :subscriptions
  end
end
