class MailingsActionsWorker
  include Sidekiq::Worker
  sidekiq_options queue: :emails

  def perform method_name, options = {}
    options.symbolize_keys! if options
    create(options)   if method_name.to_s =~ /\Acreate\z/  # create
    update(options)   if method_name.to_s =~ /\Aupdate\z/  # update
    deliver(options)  if method_name.to_s =~ /\Adeliver\z/ # deliver
  end

  def create options = {}
    @mailing = Mailing.find_by_id(options[:id])
    @mailing.recipients.each do |recipient|
      #MailingsWorker.perform_at(Time.zone.parse(@mailing.send_at).utc, 'deliver', id: @mailing.id, recipient: recipient)
      MailingsWorker.perform_at(@mailing.send_at, 'deliver', id: @mailing.id, recipient: recipient)
    end
  end

  def deliver options = {}
    MailingMailer.send_mailing(options.symbolize_keys!).deliver
  end

  def update options = {}
    @mailing = Mailing.find_by_id(options[:id])
    @mailing.purge_queue!
    @mailing.recipients.each_with_index do |recipient, index|
      MailingsWorker.perform_at(@mailing.paced_send_at(index), 'deliver', id: @mailing.id, recipient: recipient)
    end
  end

end
