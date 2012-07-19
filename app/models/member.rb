class Member < ActiveRecord::Base

  include MyTools

  Devise.setup do |config|
    # ==> Mailer Configuration
    # Configure the e-mail address which will be shown in Devise::Mailer,
    # note that it will be overwritten if you use your own mailer class with default "from" parameter.
    config.mailer_sender = "admin@ceres-recycle.org"
    config.authentication_keys = [ :username ]
    config.case_insensitive_keys = [ :username ]
    config.strip_whitespace_keys = [ :username ]

  end
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable, :registerable,
         #:recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :contact_email, :user_name, :password, :password_confirmation, :remember_me
  attr_accessible :activity, :address, :billing_address,
    :billing_city, :billing_country, :billing_postal_code, :category,
    :city, :company, :country, :postal_code, :vat_number,
    :logo_file, :membership_file, :start_date

  has_many :contacts, :inverse_of => :contact
  accepts_nested_attributes_for :contacts

  mount_uploader :logo_file, MemberFilesUploader
  mount_uploader :membership_file, MemberFilesUploader

  after_save :qr_encode

  #after_save qr_encode(color = "#41AD49")

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

  def qr_encode url = "http://www.ceres-recycle.org", scale = 3, margin = 0
    require 'open3'
    path = "#{Rails.root}/public/assets/uploads/"
    outfile = path + qr_code_name

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
