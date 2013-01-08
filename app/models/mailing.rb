class Mailing < ActiveRecord::Base
  attr_accessible :html_version, :send_at, :status, :subject, :email_template_id, :article_ids, :to, :cc, :bcc, :countries, :tags
  belongs_to :email_template, :inverse_of => :mailings

  has_and_belongs_to_many :articles

  accepts_nested_attributes_for :articles

  before_validation :check_countries_and_tags
  before_save       :update_send_at
  after_save        :delay_template!
  before_destroy    :purge_queue!, :redis_flush!

  validates :subject,           presence: true, uniqueness: true
  validates :email_template_id, presence: true
  validates :article_ids,       presence: true
  #validates :to,                presence: true

  # Create a new Destinee object that will extract and convert tags in :to,
  # :bcc and :cc to emails addresses.
  #
  #   @mailing.prepare_destinees_before_send
  #   # => { to: ["email addrs..."], cc: ["email addrs..."], bcc: ["emails..."] }
  def prepare_destinees_before_send
    Destinee.new(to, cc, bcc).list
  end

  def contact_to_select2_hidden_input
    articles.map(&:to_select2).to_json
  end

  def articles_to_select2_hidden_input
    articles.map(&:to_select2).to_json
  end

  # Create a Hash of options that will be used by prepare_perform_arguments to
  # set up the final arguments before delivering emails.
  # Options are:
  # * mailing_id:   @mailing.id
  # * to:           Array of email addresses
  # * cc:           Array of email addresses
  # * bcc:          Array of email addresses
  # * at:           Schedule Time
  #
  #   @create_arguments( { to: ["email addrs..."], cc: [...], bcc: [...] })
  #   # => { mailing_id: Integer, at: Time, to: Array, cc: Array, bcc: Array }
  def create_arguments options = {}
    options.reverse_merge!( {
        to:  [],
        cc:  [],
        bcc: []
      }).slice!( :to, :cc, :bcc)

    args = {
      mailing_id: id,
      at:         ( send_at && (send_at < (Time.now + 10.seconds)) ? Time.now + 10.seconds : send_at ),
      to:         options[:to].join(';'),
    }
    args[:cc]     = options[:cc].join(';')  if options[:cc].any?
    args[:bcc]    = options[:bcc].join(';') if options[:bcc].any?
    args
  end

  # Create an array of hashes that will be passed on as arguments to MailingWorker.deliver.
  # Hashes are divided in 2:
  # * first, emails to send to :to and :cc
  # * then the rest of the emails to send to :bcc, with a :to equal to "no-reply@ceres-recycle.org"
  #
  #   @mailing.prepare_perform_arguments
  #   # => []
  #
  def prepare_perform_arguments
    perform_arguments = []
    destinees         = prepare_destinees_before_send
    puts destinees

    perform_arguments.append( create_arguments( to: destinees[:to], cc: destinees[:cc] ) )
    destinees[:bcc].each_slice(ENVIRONMENT_CONFIG[:bulk_email_send_limit].to_i) do |sliced|
      perform_arguments.append( create_arguments( to: ["no-reply@ceres-recycle.org"], bcc: sliced) ) unless sliced.empty?
      binding.pry
    end
    perform_arguments
  end

  def email_send_interval
    ENVIRONMENT_CONFIG[:email_send_interval]
  end

  # Add a delay, defined in Tuna.yml, to the send_at attribute. This is used
  # when enqueueing emails to MailingsSenderWorker
  #
  def paced_send_at index
    if index.is_a?(Integer) && index > 0
      self.send_at + (index * self.email_send_interval)
    else
      self.send_at
    end
  end

  def recipients
    @_recipients ||= Contact.email_addresses_tagged_for_mailing(self.tags, self.countries)
  end

  def render_template
    @_template ||= ERB.new(self.email_template.content).result(binding)
  end

  def add_recipient recipient
    $redis.sadd(self.redis_key(:recipients), recipient)
  end

  def template!
    $redis.set(self.redis_key(:template), self.render_template)
  end

  def template
    $redis.get(self.redis_key(:template))
  end

  def queue
    queue = Sidekiq::ScheduledSet.new
    queue.select do |job|
      job.args[0] == "deliver" &&
      job.args[1]["id"] == self.id
    end
  end

  #def reschedule_queue! time
    #queue.map do |job|
      #job.at = self.send_at
    #end
  #end

  def purge_queue!
    queue.map(&:delete)
  end

 ###############################################################
#                                                               #
#                                                               #
#                         Protected Area                        #
#                                                               #
#                                                               #
 ###############################################################
  protected

  def check_countries_and_tags
    true
    if self.countries.blank? and self.tags.blank?
      self.errors.add(:tags, "and/or Countries can't be blank")
      self.errors.add(:countries, "and/or Tags can't be blank")
      false
    end
  end

  # Check if send_at attribute is not in the Past ( 10 seconds)
  # and set send_at seconds to 00
  def update_send_at
    self.send_at = if (self.send_at + 10.seconds).past?
      Time.now + 1.minute
    else
      self.send_at
    end.change(sec: 0)
  end

  # helper method to generate redis keys
  def redis_key(str)
    env = "#{Rails.env}-#{Rails.application.class.to_s.downcase}"
    "#{env}:mailing:#{self.id}:#{str}"
  end

  def delay_template!
    self.delay.template!
  end
  def redis_flush!
    [:template].each do |key|
      $redis.del(self.redis_key(key))
    end
  end
end
