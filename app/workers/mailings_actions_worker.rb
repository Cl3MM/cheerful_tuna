class MailingsActionsWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default

  def perform method_name, options = {}
    options.symbolize_keys! if options
    @mailing = Mailing.find_by_id(options[:id])
    @mailing.purge_queue! if method_name.to_s =~ /\Aupdate\z/  # update
    @mailing.recipients.each_with_index do |recipient, index|
      #MailingsWorker.perform_at(Time.zone.parse(@mailing.send_at).utc, 'deliver', id: @mailing.id, recipient: recipient)
      MailingsSenderWorker.perform_at(@mailing.paced_send_at(index), 'deliver', id: @mailing.id, recipient: recipient)
    end
  end

end
