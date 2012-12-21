# encoding: UTF-8
class EmailListing < ActiveRecord::Base
  attr_accessible :name, :per_line, :countries, :tags, :operator, :tag_selector

  after_validation :check_countries_and_tags

  #before_update :check_name

  validates :name, uniqueness: true, presence: true

  def countries_to_a
    countries.split(";")
  end

  def emails
    contacts = Contact.active_contacts
    contacts = contacts.where('contacts.country in (?)', self.countries_to_a) unless self.countries.blank?
    contacts = contacts.tagged_with(self.tags.split(",")) unless self.tags.blank?
    contacts.nil? ? [] : contacts.joins(:emails).select('emails.address').order('emails.address ASC')
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
