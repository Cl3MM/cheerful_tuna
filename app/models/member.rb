#encoding: utf-8
class Member < ActiveRecord::Base

  include MyTools

#  validate :validate_contact_uniqness
  #def validate_contact_uniqness
    ##Hash[Contact.all.map{|c| [c.id,[c.company,c.country, c.address, c.website]]}]
    #errors[:base] << "C'est la merde"
    #errors.add(:emails, "Tututu")
  #end

  ## Include default devise modules. Others available are:
  ## :token_authenticatable,
  ## :lockable, :timeoutable and :omniauthable

  #devise :database_authenticatable, :timeoutable, :lockable, :confirmable,
         #:recoverable, :rememberable, :trackable, :validatable ,
          #authentication_keys: [ :user_name ], case_insensitive_keys: [ :user_name ], strip_whitespace_keys: [ :user_name ],
            #timeout_in: 15.minutes, lock_strategy: :failed_attempts, unlock_keys: [ :user_name ], unlock_strategy: :email,
            #allow_unconfirmed_access_for: 0, maximum_attempts: 5, reconfirmable: false  # :registerable,

  #def attempt_set_password(params)
    ##raise "c'est la merde :("
    #p = {}
    #p[:password] = params[:password]
    #p[:password_confirmation] = params[:password_confirmation]
    #update_attributes(p)
  #end

  #def only_if_unconfirmed
    #pending_any_confirmation {yield}
  #end
  #def password_required?
    ## Password is required if it is being set, but not for new records
    #if !persisted?
      #false
    #else
      #!password.nil? || !password_confirmation.nil?
    #end
  #end
  #def has_no_password?
    #self.encrypted_password.blank?
  #end
  # Setup accessible (or protected) attributes for your model

  attr_accessible :email, :user_name#, :password, :password_confirmation, :remember_me
  attr_accessible :activity, :address, :billing_address,
    :billing_city, :billing_country, :billing_postal_code, :category,
    :city, :company, :country, :postal_code, :vat_number, :web_profile_url,
    :logo_file, :membership_file, :start_date, :is_approved

  #has_many :contacts, :inverse_of => :contact
  #accepts_nested_attributes_for :contacts

  validates_presence_of :company, :country, :email, :user_name
  validates :user_name, uniqueness: true
  validates :email, uniqueness: true

  #def self.generate_username str
    #names = Member.all.map(&:user_name).to_set
    #username = MyTools.friendly_user_name str
    #Rails.logger.debug "username:#{username}"
    #Rails.logger.debug "names:#{names.to_a.to_s}"
    #while names.include? username
      #username = "#{MyTools.friendly_user_name(str)}_#{MyTools.generate_random_string 4}"
    #end
    #username
  #end
  mount_uploader :logo_file, MemberFilesUploader
  mount_uploader :membership_file, MemberFilesUploader

  after_save :qr_encode, on: :create

  def qr_code_name
    hash_data_path = "qr_code://#{self.class.to_s.underscore}/#{self.company}/#{self.created_at}"
    "#{hash_hash(hash_data_path)}.png"
  end

  def qr_code_asset_url
    f = "#{Rails.root}/public/assets/uploads/#{qr_code_name}"
    asset = "uploads/#{qr_code_name}"
    File.exist?(f) ? asset : nil
  end

  def qr_code_path
    f = "#{Rails.root}/public/assets/uploads/#{qr_code_name}"
    File.exist?(f) ? f : nil
  end

  def qr_encode url = "http://www.ceres-recycle.org/", scale = 3, margin = 0
    require 'open3'
    path = "#{Rails.root}/public/assets/uploads/"
    outfile = path + qr_code_name
    url = self.web_profile_url
    FileUtils.mkpath(path) unless File.directory?(path)

    cmd = "qrencode -m #{margin} -o #{outfile} -s #{scale} '#{url}'"
    stdin, stdout, stderr = Open3.popen3(cmd)
    Rails.logger.debug("[QRencode]stdout: #{stdout.readlines}")
    Rails.logger.debug("[QRencode]stderr: #{stderr.readlines}")
  end

end
    #require 'rqrcode'
    #require 'RMagick'
    #path = "#{Rails.root}/app/public/assets/uploads/#{self.class.to_s.underscore}/qr_code/#{id}/"
    ##path = "/tmp/public/uploads/#{self.class.to_s.underscore}/qr_code/#{id}/"

    #qr = RQRCode::QRCode.new(url)
    #size  = qr.modules.count * scale
    #img   = Magick::Image.new(size, size)do
         #self.background_color = color
           ##"#41AD49"
    #end

    ## draw matrix
    #qr.modules.each_index do |r|
      #row = r * scale
      #qr.modules.each_index do |c|
        #col = c * scale
        #dot = Magick::Draw.new
        #dot.fill(qr.dark?(r, c) ? 'black' : color)
        #dot.rectangle(col, row, col + scale, row + scale)
        #dot.draw(img)
      #end
    #end
    #FileUtils.mkpath(path) unless File.directory?(path)
    #img.write(outfile)
    #img.filename
  #end
