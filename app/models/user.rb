class User < ActiveRecord::Base
  has_many :contacts

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable

  # :registerable, :recoverable,

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role, :username
  # attr_accessible :title, :body

  def is_admin?
    role == "administrator" ? true : false
  end

end
