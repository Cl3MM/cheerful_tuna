class User < ActiveRecord::Base
  has_many :contacts

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable, :recoverable #, :registerable, :recoverable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role, :username
  # attr_accessible :title, :body

  #scope :by_name, lambda do |name|
    #where("username = ?", name)
  #end

  def self.average_contact_per_month date
    Hash[User.all.map do |u|
      contact_per_day = u.contacts.per_month(date).count #=> {Mon, 25 Jun 2012=>1, Tue, 26 Jun 2012=>177, Fri, 06 Jul 2012=>1, Sun, 08 Jul 2012=>4}
      average = contact_per_day.reduce(0){|s, (k,v)| s += v } / contact_per_day.keys.count unless contact_per_day.empty? # Sum up all the contacts then divide by number of days
      [u.username.capitalize, average] if average
    end.compact.sort_by { |name, age| name }]
  end

  def self.average_contact_per_day
    Hash[User.all.map do |u|
      contact_per_day = u.contacts.group('date(created_at)').count #=> {Mon, 25 Jun 2012=>1, Tue, 26 Jun 2012=>177, Fri, 06 Jul 2012=>1, Sun, 08 Jul 2012=>4}
      average = contact_per_day.reduce(0){|s, (k,v)| s += v } / contact_per_day.keys.count unless contact_per_day.empty? # Sum up all the contacts then divide by number of days
      [u.username.capitalize, average] if average
    end.compact.sort_by { |name, age| name }]
  end

  def is_admin?
    role == "administrator" ? true : false
  end

end
