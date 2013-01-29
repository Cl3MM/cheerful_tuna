# encoding: UTF-8

require 'rubygems'
require 'roo'
require 'nokogiri'
require 'digest/md5'
require 'csv'
require 'ap'

namespace :mb do

  desc "Mail 2012 due members"
  task :mail_2012_due_members => :environment do
    Member.all.each do |member|
      if (member.id != 35 ) && (not member.suspended?) && (member.end_date < Date.today)
        #member.delay.suspend!
        puts "\nMember #id: #{member.id} | company: #{member.company}"
        member.contacts.each do |contact|
          puts " - contact #id: #{contact.id} | company: #{contact.full_name}"
          puts "   * emails     : #{contact.email_addresses.join(' | ').truncate(120)}"
          #MemberMailer.delay.membership_2013_renewal(contact.full_name, contact.email_addresses)
        end
      end
    end
  end

end

