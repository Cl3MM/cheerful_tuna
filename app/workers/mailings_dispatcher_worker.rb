class MailingsDispatcherWorker
  include Sidekiq::Worker
  sidekiq_options queue: "default"

  def perform method_name, options = {}
    options.symbolize_keys! if options
    @mailing = Mailing.find_by_id(options[:id])
    @mailing.purge_queue! if method_name.to_s =~ /\Aupdate\z/  # update
    @mailing.recipients.each_with_index do |recipient, index|
      options = { id: @mailing.id, recipient: recipient }
      options.merge( index: :first )  if index == 0
      options.merge( index: :last )   if index == 0

      @mailing.update_status(:sending) # updating mailing status

      MailingsSenderWorker.perform_at(@mailing.paced_send_at(index), 'deliver', options)
    end
  end

end
