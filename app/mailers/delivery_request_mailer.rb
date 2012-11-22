class DeliveryRequestMailer < ActionMailer::Base
  default from: "no-reply@ceres-recycle.org"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.member_mailer.generic_send.subject
  #
  def send_confirmation_email(delivery_request)
    @delivery_request = delivery_request
    mail to: @delivery_request.email, subject: "CERES - Delivery Request confirmation"
  end
end
