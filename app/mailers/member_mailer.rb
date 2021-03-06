## encoding: utf-8

class MemberMailer < ActionMailer::Base
  default from: "CERES <contact@ceres-recycle.org>", bcc: "contact@ceres-recycle.org"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
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

  def erp_phone_call_campaign_march name, email
    @name = name
    mail to: email, subject: "CERES-ERP Italia partnership : Action required - Phone call campaign to start regarding GSE regulations in Italy", from: "CERES <no-reply@ceres-recycle.org>", importance: "High", 'X-Priority' => '1'
  end

  def retroactive_clarification to
    mail to: to, subject: "Clarification about the retroactive guarantee fee in Italy", from: "CERES <italia@ceres-recycle.org>", importance: "High", 'X-Priority' => '1', bcc: ""
  end

  def gse_clarification to, cc
    mail cc: cc, to: to, subject: "[Mailing to CERES Members] Urgent | CERES: Clarification about the new GSE regulation ", from: "operations@ceres-recycle.org", importance: "High", 'X-Priority' => '1', bcc: ""
  end

  def italian_producers_march to, cc
    mail cc: cc, to: to, subject: "[Mailing to Italian Distributors] Urgente : Chiarimenti in merito alla regolamentazione del Conto Energia V relativa alla fine del ciclo di vita dei moduli fotovoltaici", from: "CERES <italia@ceres-recycle.org>", importance: "High", 'X-Priority' => '1', bcc: ""
  end

  def notify_ceres_erp_partnership name, emails
    mail to: emails, subject: "CERES - ERP Italia Partnership", from: "operations@ceres-recycle.org"
  end

  def collection_points_april_2013 name, emails
    @name = name
    mail to: emails, subject: "CERES Expands its Collection Network", from: "CERES <no-reply@ceres-recycle.org>", bcc: ""
  end

  def notify_membership_expiry name, emails
    @name = name
    mail to: emails, subject: "CERES - Your CERES membership has expired", from: "no-reply@ceres-recycle.org"
  end

  def gse_figures_september_december name, emails
    @name = name
    mail to: emails, subject: "CERES - Important: Action regarding Italian traceability requirements for PV modules", from: "noreply@ceres-recycle.org"
  end

  def transenergie_june_2013 emails
    mail to: emails, subject: "Rappel : Forum Transenergie éco-conception / Recyclage photovoltaique - 13 Juin", from: "CERES <no-reply@ceres-recycle.org>", bcc: ""
  end

  def wheelie_bin_05_2013 emails
    mail to: emails, subject: "[CERES] - WEEE transposition update: the wheelie bin logo"
  end

  def membership_2013_renewal name, emails
    @name = name
    attachments['CERES_2013_Service_Agreement.pdf'] = File.read("#{Rails.root}/public/assets/members/CERES_2013_Service_Agreement.pdf")
    attachments['CERES_2013_Membership_form.pdf'] = File.read("#{Rails.root}/public/assets/members/CERES_2013_Membership_form.pdf")
    mail to: emails, subject: "CERES - 2013 Membership renewal", from: "noreply@ceres-recycle.org", bcc: ""
  end
  def final_mailing emails
    mail to: emails, subject: "[CERES] - Important organizational change", bcc: "contact@ceres-recycle.org, sbesanger@gmail.com", from: "CERES <no-reply@ceres-recycle.org>"
  end

end
