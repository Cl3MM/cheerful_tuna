module Membership
  extend ActiveSupport::Concern

  included do
    before_save :set_current_subscription
    has_many    :subscriptions, as: :owner, dependent: :destroy, inverse_of: :owner
    #attr_accessible :subscriptions_attributes
    #accepts_nested_attributes_for :subscriptions
  end

  def current_subscription
    Rails.logger.debug "+" * 120
  end
  #def self.included(base)
    #base.attr_accessible :subscriptions_attributes
    #base.has_many :subscriptions, as: :owner, dependent: :destroy, inverse_of: :owner
    #base.accepts_nested_attributes_for :subscriptions
  #end

  module ClassMethods
    def mandatory_documents
      if const_defined?( "#{self.name.pluralize}_membership_documents".upcase )
        eval "#{self.name.pluralize.upcase}_membership_documents".upcase
      else
        {}
      end
    end
  end

end
