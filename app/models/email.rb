class Email < ActiveRecord::Base
  attr_accessible :address, :contact_id, :has_bounced
end
