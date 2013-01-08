# encoding: UTF-8
class EmailListing < ActiveRecord::Base
  attr_accessible :name, :per_line, :countries, :tags, :operator, :tag_selector

  before_validation :check_countries_and_tags

  #before_update :check_name

  validates :name, uniqueness: true, presence: true

  def countries_to_a
    countries.split(";")
  end

  def emails
    Contact.email_addresses_tagged_for_mailing self.tags, self.countries_to_a
  end

  protected

  def check_countries_and_tags
    true
    if self.countries.blank? and self.tags.blank?
      self.errors.add(:base, "Please fill either Countries or Tags field")
      false
    end
  end

  def check_name
    if EmailListing.find_by_name(self.name)
      self.errors.add(:base, "Name already exists")
      false
    else
      true
    end
  end
end
