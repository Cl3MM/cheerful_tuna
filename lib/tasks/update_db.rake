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
  end

  desc "Reset Database"
  task :find_invalid => :environment do
    Contact.all.each do |c|
      c.attributes.each do |a|
        unless a.class == Array
          a.force_encoding "utf-8"
          unless a.valid_encoding?
            puts "Invalid attribute: #{a} in user id: #{c.id}"
            #email.encode!("utf-8", "utf-8", :invalid => :replace)
            #user.update_attribute(:school_email, email)
          end
        end
      end
    end
  end
end
