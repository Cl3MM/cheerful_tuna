class MailingsSenderWorker
  include Sidekiq::Worker
  sidekiq_options queue: "emails"

  def perform method_name, options = {}
    options.symbolize_keys! if options
    MailingMailer.send_mailing(options.symbolize_keys!).deliver
  end

end
