class Email < ActiveRecord::Base
  belongs_to :contact, inverse_of: :emails, touch: true
  attr_accessible :address, :contact_id, :has_bounced

  validates_uniqueness_of :address
  validates_presence_of :address
  validates_presence_of :contact

  before_validation :clean_up_address

  private

  def clean_up_address
    self.address = address.strip.gsub(/\n/,";").gsub(/ /, "").downcase
  end
end
