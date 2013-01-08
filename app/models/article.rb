class Article < ActiveRecord::Base
  acts_as_taggable
  versioned #:dependent => :tracking

  has_and_belongs_to_many :mailings

  attr_accessible :content, :title

  validates :content, uniqueness: true, presence: true
  validates :title,   uniqueness: true, presence: true

  # Generate Json format for select2
  def to_select2
    { id: self.id, text: self.title.html_safe }
  end
end
