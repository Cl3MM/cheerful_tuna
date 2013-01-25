#encoding: utf-8
class Member < ActiveRecord::Base

  include MyTools
  paginates_per 25
  acts_as_taggable_on           :brand, :activity
  mount_uploader                :logo_file, MemberFilesUploader
  mount_uploader                :membership_file, MemberFilesUploader

  has_and_belongs_to_many       :contacts
  accepts_nested_attributes_for :contacts

  attr_accessible :user_name, :contact_ids#, :password, :password_confirmation, :remember_me
  attr_accessible :address, :billing_address, :address_continued, :activity_list,
                  :billing_city, :billing_country, :billing_postal_code, :category,
                  :city, :company, :country, :postal_code, :vat_number, :web_profile_url,
                  :logo_file, :membership_file, :start_date, :is_approved, :brand_list #, :civility

  attr_reader :end_date, :category_price

  validates_presence_of :user_name, :company, :country, :web_profile_url,
                        :start_date, :category, :address, :city, :postal_code,
                        :activity_list, :contact_ids
  validates             :category, inclusion: { in: %w[Free A B C D],
                                                message: "%{value} is not a valid category" }
  validates             :company, uniqueness: { scope: [:country, :address],
                                                message: " already exists with similar country and address." }

  before_create   { generate_token(:auth_token) }
  after_save      :qr_encode_delayed, on: [:create, :update]
  before_save     :clean_data

  scope :past_due_date, where( 'DATE(start_date) <= ?', Date.today - 1.year )

  def self.member_status
    MEMBERS_STATUS
  end

  def find_with_status status
    if Member.member_status.include? status
      if status == "due_date"
        Member.all
      end
    else
      Member.all
    end
    Member.all
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
      #send("#{column}=", SecureRandom.urlsafe_base64)
    end while Member.exists?(column => self[column])
  end

  def create_member_tag_on_contacts
    contacts.each do |contact|
      member_tags = contact.tag_list
      unless member_tags.include? "member"
        puts "Creating Tag"
        member_tags << "member"
        contact.tag_list = member_tags.join(",")
        contact.save
      end
    end
  end

  def suspend
    self.status = :suspended
  end

  def end_date_to_human
    day   = end_date.strftime('%d').to_i.ordinalize
    month = end_date.strftime('%B')
    year  = end_date.strftime('%Y')
    "#{month} #{day}, #{year}"
  end

  def end_date
    self.start_date.strftime("%Y").to_i < 2013 ? self.old_end_date : self.start_date.end_of_year
  end

  def old_end_date
   (self.start_date + 1.year).prev_month.end_of_month
  end

  def category_price
    prices = {"A" => "5000€", "B" => "2000€", "C" => "1000€", "D" => "600€", "FREE" => "Free" }
    prices[self.category.upcase]
  end

  def self.find_encrypted_member checksum
    Member.all.each do |member|
      if checksum == Digest::MD5.hexdigest(member.company)
        return member
      end
    end
    false
  end

  def qr_code_dir
    "#{Rails.root}/#{ENVIRONMENT_CONFIG[:members]["qr_code_dir"]}" # create dir from config
  end

  def qr_code_name
    hash_data_path = "qr_code://#{self.class.to_s.underscore}/#{self.company}/#{self.created_at}"
    "#{hash_hash(hash_data_path)}.png"
  end

  def qr_code_asset_url
    asset_path = qr_code_dir.split("/").drop_while { |dir| not dir =~ /assets/ } [1..-1].join("/")
    asset = asset_path.nil? ? "invalid" : "#{asset_path}/#{qr_code_name}"
    File.exist?("#{Rails.root}/public/assets/#{asset}") ? asset : nil
  end

  def qr_code_path
    "#{qr_code_dir}/#{qr_code_name}"
  end

  def qr_encode url = "http://www.ceres-recycle.org/", scale = 3, margin = 0
    require 'open3'
    url = self.web_profile_url
    FileUtils.mkpath(qr_code_dir) unless File.directory?(qr_code_dir)

    cmd = "qrencode -m #{margin} -o #{qr_code_path} -s #{scale} '#{url}'"
    stdin, stdout, stderr = Open3.popen3(cmd)
  end

  def qr_encode_delayed
    self.delay.qr_encode
  end

  def generate_username
    names = Member.all.map(&:user_name).to_set
    username = MyTools.friendly_user_name self.company
    Rails.logger.debug "username:#{username}"
    Rails.logger.debug "names:#{names.to_a.to_s}"
    while names.include? username
      username = "#{MyTools.friendly_user_name(company)}_#{MyTools.generate_random_string 4}"
    end
    username
  end
  def self.generate_username str
    names = Member.all.map(&:user_name).to_set
    username = MyTools.friendly_user_name str
    Rails.logger.debug "username:#{username}"
    Rails.logger.debug "names:#{names.to_a.to_s}"
    while names.include? username
      username = "#{MyTools.friendly_user_name(str)}_#{MyTools.generate_random_string 4}"
    end
    username
  end

  def self.update_auth_tokens
    Member.all.map do |m|
      token = SecureRandom.urlsafe_base64
      m.update_attribute(:auth_token, token)
      m.save
      m.auth_token
    end
  end
  protected

  def clean_data
    # trim whitespace from beginning and end of string attributes
    attribute_names.each do |name|
      if send(name).respond_to?(:strip)
        send("#{name}=", send(name).strip)
      end
    end
  end

end

  #validates :civility, :inclusion => { :in => %w[Mr Mrs Ms],
                                   #:message => "%{value} is not a valid category" }
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
