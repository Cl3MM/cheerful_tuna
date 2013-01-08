class EmailTemplate < ActiveRecord::Base
  attr_accessible :content, :language, :name
  has_many        :mailings, inverse_of: :email_template

  validates       :name,    presence: true, uniqueness: true
  validates       :content, presence: true, uniqueness: true

  def to_html
    ERB.new(content)
  end
end
