class Mailing < ActiveRecord::Base
  attr_accessible :html_version, :sendt_at, :status, :subject, :template, :article_ids

  has_and_belongs_to_many :articles

  accepts_nested_attributes_for :articles

  validates :subject,   presence: true, uniqueness: true
  validates :template,  presence: true
end
