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
      if (member.id != 65 ) && (not member.suspended?) && (member.end_date < Date.today)
        member.delay.suspend!
        puts "\nMember #id: #{member.id} | company: #{member.company}"
        member.contacts.each do |contact|
          puts " - contact #id: #{contact.id} | company: #{contact.full_name}"
          puts "   * emails     : #{contact.email_addresses.join(' | ').truncate(120)}"
          MemberMailer.delay.membership_2013_renewal(contact.full_name, contact.email_addresses)
        end
      end
    end
  end

  desc "Italian Members"
  task :italian_members => :environment do
    out = [ "nom;prénom;e-mail;société;pays" ]
    Member.all.each do |member|
      puts "\nMember #id: #{member.id} | company: #{member.company}"
      member.contacts.each do |contact|
        out << [ contact.last_name, contact.first_name, contact.emails.first.address, member.company, contact.country ].join(';')
        puts " - contact #id: #{contact.id} | company: #{contact.full_name}"
        puts "   * emails     : #{contact.email_addresses.join(' | ').truncate(120)}"
      end
      puts out.join("\n")
      File.open("#{Rails.root}/tmp/enr_list.csv", "w") { |f| f.puts out }
    end
  end

  desc "ENR Members"
  task :list_enr => :environment do
    out = [ "nom;prénom;e-mail;société;pays" ]
    Member.all.each do |member|
      puts "\nMember #id: #{member.id} | company: #{member.company}"
      member.contacts.each do |contact|
        out << [ contact.last_name, contact.first_name, contact.emails.first.address, member.company, contact.country ].join(';')
        puts " - contact #id: #{contact.id} | company: #{contact.full_name}"
        puts "   * emails     : #{contact.email_addresses.join(' | ').truncate(120)}"
      end
      puts out.join("\n")
      File.open("#{Rails.root}/tmp/enr_list.csv", "w") { |f| f.puts out }
    end
  end

  desc "Due members"
  task :due_members => :environment do
    out = [ "Company;Country;Contact Name;Phone;Mobile;Start Date;End Date;Emails" ]
    Member.all.each do |member|
      if (member.end_date < Date.today)
        puts "\nMember #id: #{member.id} | company: #{member.company}"
        member.contacts.each do |contact|
          out << [ member.company, member.country, contact.full_name, contact.phone, contact.cell, member.start_date.strftime("%B %d, %Y"), member.end_date.strftime("%B %d, %Y"), contact.email_addresses ].join(';')
          puts " - contact #id: #{contact.id} | company: #{contact.full_name}"
          puts "   * emails     : #{contact.email_addresses.join(' | ').truncate(120)}"
        end
        puts out.join("\n")
        File.open("#{Rails.root}/tmp/due_members.csv", "w") { |f| f.puts out }
      end
    end
  end

  desc "Inform members about CERES/ERP partnership"
  task :test_mail_erp_partnership => :environment do
    Contact.tagged_with("Admin").each do |contact|
      MemberMailer.delay.notify_ceres_erp_partnership(contact.full_name, contact.email_addresses)
      #MemberMailer.delay.notify_ceres_erp_partnership(contact.full_name, contact.email_addresses)
    end
  end

  desc "Inform members about CERES/ERP partnership"
  task :mail_erp_partnership => :environment do
    Member.all.each do |member|
      puts "\nMember #id: #{member.id} | company: #{member.company}"
      member.contacts.each do |contact|
        puts " - contact #id: #{contact.id} | company: #{contact.full_name}"
        puts "   * emails     : #{contact.email_addresses.join(' | ').truncate(120)}"
        #MemberMailer.notify_ceres_erp_partnership(contact.full_name, contact.email_addresses).deliver
        MemberMailer.delay.notify_ceres_erp_partnership(contact.full_name, contact.email_addresses)
      end
    end
  end

  desc "Mail members for GSE figures"
  task :mail_members_for_gse_figures => :environment do
    Member.all.each do |member|
      puts "\nMember #id: #{member.id} | company: #{member.company}"
      member.contacts.each do |contact|
        puts " - contact #id: #{contact.id} | company: #{contact.full_name}"
        puts "   * emails     : #{contact.email_addresses.join(' | ').truncate(120)}"
        MemberMailer.gse_figures_september_december(contact.full_name, contact.email_addresses)
        #MemberMailer.delay.gse_figures_september_december(contact.full_name, contact.email_addresses)
      end
    end
  end

end
