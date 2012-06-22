class Email < ActiveRecord::Base
  belongs_to :contact
  attr_accessible :address, :contact_id, :has_bounced
end
