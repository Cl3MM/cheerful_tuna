class MailingMailer < ActionMailer::Base
  default from: "no-reply@ceres-recycle.org"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.member_mailer.generic_send.subject
  #
  def send_mailing(options = {} )
    raise "Options must be a hash" unless options.is_a? Hash
    @mailing  = Mailing.find_by_id(options[:id])
    mail_options = {
      subject:  @mailing.subject,
      to:       options[:recipient]
    }
    mail mail_options  do |format|
      format.html { render inline: (@mailing.template || @mailing.render_template ) }
    end
  end
end
