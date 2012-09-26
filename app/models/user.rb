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
    end.compact.sort_by { |name, avg| name }]
  end

  def self.average_contact_per_day
    Hash[User.all.map do |u|
      contact_per_day = u.contacts.group('date(created_at)').count #=> {Mon, 25 Jun 2012=>1, Tue, 26 Jun 2012=>177, Fri, 06 Jul 2012=>1, Sun, 08 Jul 2012=>4}
      average = contact_per_day.reduce(0){|s, (k,v)| s += v } / contact_per_day.keys.count unless contact_per_day.empty? # Sum up all the contacts then divide by number of days
      [u.username.capitalize, average] if average
    end.compact.sort_by { |name, avg| name }]
  end

  def self.contacts_per_user_stats date = Date.today, timeframe = "month"
    range = (timeframe == "month" ? (date.beginning_of_month..date.end_of_month) : (date.beginning_of_week..date.end_of_week))
    contacts_by_user = User.joins(:contacts).group(:username, 'date(contacts.created_at)').where("contacts.created_at", range ).count
    labels = contacts_by_user.keys.map{|k| k.first.capitalize}.uniq.compact
    contacts_by_user_sorted = contacts_by_user.inject({}) do |result, (k, v)|
      begin
        result[k.last][k.first.capitalize] = v
      rescue
        result[k.last] = {k.first.capitalize => v}
      end
      result
    end

    {data: range.map do |day|
      labels.inject({day: day}) do |data, key|
        data[key.to_sym] = (contacts_by_user_sorted.has_key?(day) ? contacts_by_user_sorted[day][key] : 0) || 0
        data
      end
    end, labels: labels}
  end

  def self.contacts_by_user
    #Contact.group(:country).count.sort_by{|k,v| v}.map{|name, val| {label: name, value: val} }
    User.joins(:contacts).group(:username).count.sort_by{|k,v| v}.map{|name, val| {label: name.capitalize, value: val} }
  end

  def is_admin?
    role == "administrator" ? true : false
  end

end
