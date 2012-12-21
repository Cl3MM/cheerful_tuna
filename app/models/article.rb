class Article < ActiveRecord::Base
  acts_as_taggable
  versioned #:dependent => :tracking

  attr_accessible :content, :title

  validates :content, uniqueness: true, presence: true
  validates :title,   uniqueness: true, presence: true

end
