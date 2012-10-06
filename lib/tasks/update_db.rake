# encoding: UTF-8

require 'rubygems'
require 'roo'
require 'nokogiri'
require 'digest/md5'
require 'csv'
require 'ap'

namespace :udb do
  desc "Populate Country Database"
  task :populate_countries => :environment do
    @countries = Country.all
    @countries_names = @countries.map(&:english).to_set
    inserts = []
    require 'open-uri'
    doc = Nokogiri::HTML(open("http://www.culture.gouv.fr/culture/dglf/ressources/pays/ANGLAIS.HTM"))
    countries = doc.css("a").map{|x| x.text unless x.text =~ /Index|page/}.compact.to_set
    countries.each do |country|
      unless @countries_names.include? country
        inserts << "('#{Time.now}', '#{country}', 'NONE','NONE', '#{Time.now}')"
        Rails.logger.debug "[TSK][populate_country] COUNTRY ADDED: #{country}"
      end
    end
    if inserts.empty?
      Rails.logger.debug "[TSK][populate_country] NO MORE COUNTRY TO ADD"
    else
    sql = "INSERT INTO `countries` (`created_at`, `english`, `french`, `chinese`, `updated_at`) VALUES #{inserts.join(", ")};"
    ActiveRecord::Base.connection.execute sql
    end
  end

  desc "Reset Database"
  task :reset => :environment do
    ENV['CLASS'] = 'Contact'
    ENV['FORCE'] = 'true'

    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:data:load'].invoke
    Rake::Task['udb:populate_countries'].invoke
    Rake::Task['tire:import'].invoke
    u = User.find_by_username("clement")
    u.update_attributes(:password => 'adminadmin', :password_confirmation => 'adminadmin')
    u.save
  end

  desc "Clean up email whose contacts have been deleted"
  task :clean_emails => :environment do
    ids = Contact.all.map(&:id).to_set
    Email.all.map do |m|
      unless ids.include?(m.contact_id)
        puts "id: #{m.id.to_s}, email: #{m.address}"
        m.destroy
      end
    end
  end

  desc "Clean up company"
  task :upcase_company => :environment do
    Contact.all.each do |c|
      c.skip_version do
        c.update_attribute(:company, c.company.upcase)
        c.save
      end
    end
  end
  desc "Clean up database"

  task :clean => :environment do
    Contact.all.each do |c|
      c.skip_version do
        c.clean_up_attributes
        c.save
      end
    end
  end
end
