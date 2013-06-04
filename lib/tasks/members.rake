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

  desc "GSE Clarification"
  task :mail_gse_clarification => :environment do
    Member.all.each do |member|
      puts "\nMember #id: #{member.id} | company: #{member.company}"
      member.contacts.each do |contact|
        puts " - contact #id: #{contact.id} | company: #{contact.full_name}"
        puts "   * emails     : #{contact.email_addresses.join(' | ').truncate(120)}"
        MemberMailer.delay.gse_clarification(contact.full_name, contact.email_addresses)
      end
    end
  end

  #desc "Update Contact category"
  #task :update_contact => :environment do
    #tag_category = CategoriesToTags.new
    #tch = tag_category.tags_categories_hash
    #Contact.all.each do |contact|
      #c = contact.dup
      #if tch.keys.include? c.category
        #tch_tags          = tch[c.category]
        #c.tag_list  = tch.join(",")
        #c.delay_for(60.seconds).
      #end
    #end
  #end

  desc "email retroactive clarification"
  task :mail_retroactive_clarification => :environment do
    Member.all.each do |member|
      puts "\nMember #id: #{member.id} | company: #{member.company}"
      member.contacts.each do |contact|
        puts " - contact #id: #{contact.id} | company: #{contact.full_name}"
        puts "   * emails     : #{contact.email_addresses.join(' | ').truncate(120)}"
        MemberMailer.delay.retroactive_clarification(contact.email_addresses)
      end
    end
  end

  desc "erp phone call campaign march"
  task :erp_phone_call_campaign_march => :environment do
    Member.all.each do |member|
      unless [28, 45].include?(member.id)
        puts "\nMember #id: #{member.id} | company: #{member.company}"
        member.contacts.each do |contact|
          puts " - contact #id: #{contact.id} | company: #{contact.full_name}"
          puts "   * emails     : #{contact.email_addresses.join(' | ').truncate(120)}"
          MemberMailer.delay.erp_phone_call_campaign_march(contact.full_name, contact.email_addresses)
        end
      end
    end
  end

  desc "Mailing Collection Points April 2013"
  task :cp_04_2013 => :environment do
    countries = %w(Austria Belgium Bulgaria Cyprus Czech Republic Denmark Estonia Finland Germany Greece Hungary Ireland Latvia Lithuania Luxembourg Malta Netherlands Poland Portugal Romania Slovakia Slovenia Spain Sweden United Kingdom)
    tags      = Contact.tag_counts.map { |t| t.name if t.name.downcase =~ /instal|distri/ }.compact.uniq
    Contact.tagged_with(tags, any: true).where('country IN (?)', countries).each do | contact |
      MemberMailer.delay.collection_points_april_2013(contact.full_name, contact.email_addresses)
    end
    MemberMailer.delay.collection_points_april_2013("Clement Roullet", "clement.roullet@gmail.com, clement.roullet@ceres-recycle.org")
  end

  desc "Mailing Wheelie bin May 2013"
  task :wb_05_2013 => :environment do
    Member.all.each do |member|
      unless [38].include?(member.id)
        puts "\nMember #id: #{member.id} | company: #{member.company}"
        member.contacts.each do |contact|
          puts " - contact #id: #{contact.id} | company: #{contact.full_name}"
          puts "   * emails     : #{contact.email_addresses.join(' | ').truncate(120)}"
          MemberMailer.delay.wheelie_bin_05_2013(contact.email_addresses)
        end
      end
    end
  end

  desc "Mailing Transenergie June 2013"
  task :transenergie_06_2013 => :environment do
    Contact.where('country IN (?)',["France"]).each do | contact |
      MemberMailer.delay.transenergie_june_2013(contact.email_addresses)
    end
  end

  desc "Update Contact category"
  task :update_contact => :environment do
    tag_category = CategoriesToTags.new
    tch = tag_category.tags_categories_hash
    Contact.all.each do |contact|
      c = contact.clone
      if tch.keys.include? c.category
        tch_tags    = tch[c.category]
        c.tag_list.add(tch_tags)
        c.save
        c = nil
      end
    end
  end

  def debug_job tags
    Rails.logger.debug "contact id: #{:id} | tag_list: #{tags}"
  end
end
