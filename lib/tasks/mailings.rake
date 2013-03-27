# encoding: UTF-8

require 'ap'

namespace :mail do

  desc "Mail Italian contacts"
  task :italians => :environment do
    require 'set'
    require 'open-uri'
    enf_emails      = open("#{Rails.root}/tmp/emails.txt").read.split("\n").to_set
    italian_emails  = Contact.where("country = ?", ["Italy"]).joins(:emails).select('emails.address').map(&:address).to_set
    members_emails  = Contact.tagged_with("member").joins(:emails).select('emails.address').map(&:address).to_set

    emails = enf_emails + italian_emails - members_emails
    emails << ["clement.roullet@gmail.com", "nicolas.defrenne@ceres-recycle.org", "sabrina.zanin@erp-recycling.org", "mohamed.osman@erp-recycling.org", "sbesanger@gmail.com", "jppalier@ceres-recycle.org", "jppalier@ceres-recycle.cn", "jppalier@clean-power-solar.com"]
    emails.uniq.each do |email|
      MemberMailer.delay.italian_producers_march(email)
    end
  end

end

