class JoomlaUser < ActiveRecord::Base
  establish_connection "joomla_ceres_#{Rails.env.downcase == "test" ? "development" : Rails.env}"
  #establish_connection "joomla_ceres_development"
  self.table_name = 'CERES_users'

  attr_accessible :activation, :block, :email, :lastResetTime, :lastvisitDate, :name, :params, :password, :registerDate, :resetCount, :sendEmail, :username, :usertype


  def password_salt
    self.password.split(":").last
  end
  def password_hash
    self.password.split(":").first
  end

  def authenticate user_password
    Digest::MD5.hexdigest( user_password.html_safe + self.password_salt) == self.password_hash
  end
  def self.authenticate_joomla_user user_name, user_password
    user = CeresUser.find_by_username(user_name.html_safe)
    user ? Digest::MD5.hexdigest( user_password.html_safe + user.password_salt) == user.password_hash : false
  end

  def find_tuna_member
    Member.find_by_user_name(self.username)
  end
end
