class MemberMailer < ActionMailer::Base
  default from: "contact@ceres-recycle.org", bcc: "contact@ceres-recycle.org"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.member_mailer.generic_send.subject
  #
  def newswire name, email
    mail to: "#{name} <#{email}>", subject: "CERES - Italian regulations update"
  end

  def generic_send name, email
    Rails.logger.debug "*"*10 + " Sending email !!!!" + "*"*10
    @name = name
    mail to: email, subject: "Mailing Test" if email and name
  end

  def notify_membership_expiry name, emails
    @name = name
    mail to: emails, subject: "CERES - Your CERES has expired"
  end
end
