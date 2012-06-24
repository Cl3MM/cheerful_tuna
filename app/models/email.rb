class Email < ActiveRecord::Base
  belongs_to :contact  
  attr_accessible :address, :contact_id, :has_bounced

  validates_uniqueness_of :address
  validates_presence_of :address
end
