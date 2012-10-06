#encoding: utf-8
require 'awesome_print'
namespace :senators do

  YAML_SENATORS_FILE = "#{Rails.root}/lib/tasks/senators.yml"

  class String
    def is_lower?
      if self.downcase == self
        true
      else
        false
      end
    end
    def is_upper?
      if self.upcase == self
        true
      else
        false
      end
    end
  end
  class Senator
    attr_accessor :url, :file, :name, :departement, :email, :first_name, :last_name, :title, :region

    def initialize( u, f, fn = nil, d = nil, e = nil, l = nil, r = nil, t = nil )
      @url = u
      @file = f
      @departement = d
      @email = e
      @first_name = fn
      @last_name = l
      @region = r
      @title = t
      @name = nil
    end

    def save_page(page, dir = LOCAL_DIR)
      File.open("#{LOCAL_DIR}/#{@file}",'w') {|f| page.write_html_to f}
    end

    def split_title
      if @title =~ /représentant les Français établis hors de France/
        @region = @departement = "Sénateur représentant les Français établis hors de France"
      else
        @region = @title.scan(/Sénat(?:eur|rice) (?:d'|des?|du) ?(?:l'|le|la)?(.*)\(/).flatten.first
        @departement = @title.scan(/\((.*)\)/).flatten.first
      end
      @departement.strip! unless departement.nil?
      @region.strip! unless region.nil?
    end

    def split_name
      up, down, other = [], [], []
      @name.split(" ").each do |n|
        if n.is_upper?
          up << n
        elsif n.is_lower?
          down << n
        else
          other << n
        end
      end
      @first_name = other.join(" ").strip
      @last_name = [down.join(" "), up.join(" ")].join(" ").gsub(/ +/," ").strip
      [@first_name, @last_name]
    end
  end

  class Senators
    attr_accessor :base_url, :index_page, :index_url, :mode, :yaml_senators_file, :senators
    def initialize(b = BaseURL, i = IndexPage, m = "-online", y = YAML_SENATORS_FILE, c = CSV_FILE)
      @base_url = b
      @index_page = i
      @index_url ="#{@base_url}/#{@index_page}"
      @senators = []
      @mode = (m =~ /online/ ? "online" : "offline")
      @yaml_senators_file = y
      @csv_file = c
      self.initialize_senators_list_from_web
    end

    def initialize_senators_list_from_web
      html = open(@index_url).read
      doc = Nokogiri::HTML(html)
      doc.css("a").each do |link|
        if link['href'] =~ /\/senateur\//i
          @senators << Senator.new(url = link['href'], file = link['href'].reverse.chop.reverse.gsub('/','*'))
        end
      end
    end

    def populate_senators_list
      @senators.each do |senator|
        path = "#{LOCAL_DIR}/#{senator.file}"
        #puts path.cyan
        html = if File.exists? path
                 path_exists = "File".cyan.bold + " #{senator.file.reset} " +"Exists !".cyan.bold
                 File.open(path).read
               else
                 path_exists = "File does not Exist !".blue.bold
                 open("#{BaseURL}#{senator.url}").read
               end
        page = Nokogiri::HTML(html, nil, "iso-8859-1")

        senator.name = page.at_css(".title-01").content.gsub("\n"," ")
        senator.title = page.at_css(".subtitle-02").content.gsub("\n"," ")
        senator.email = (page.at_css(".link-color-01") ? page.at_css(".link-color-01").content.gsub("\n"," ") : nil)
        senator.split_name
        senator.split_title
        #puts "Saving file to directory...".green.bold
        #File.open(path,'w') {|f| page.write_html_to f}
        unless senator.region =~ /représentant/
          puts "#{(senator.first_name + " " + senator.last_name).ljust(26).blue}: #{senator.departement.ljust(30)}| #{senator.region.ljust(24)}| #{path_exists}"
        else
          puts "#{senator.name.ljust(26).blue}: #{"-".ljust(30)}| #{"-".ljust(24)}| #{path_exists}"
        end
        senator.save_page page
      end
    end


    def dump_yml
      File.open(@yaml_senators_file,'w') {|f| f.write self.to_yaml}
    end

    def dump_csv
      data  = ["Prénom", "Nom", "email", "region", "departement"].join(';') + "\n"
      data += @senators.map{|sen| [sen.first_name, sen.last_name, sen.email, sen.region, sen.departement ].join(";") unless sen.email.nil?}.compact.join("\n")
      File.open(@csv_file,'w') {|f| f.write data}
    end
  end

  # The desc is only a human readable comment displayed in the tasks list.
  desc "Search for trailers for films of the day"
  task :import => :environment do
    senators = YAML::load( File.read(YAML_SENATORS_FILE) )
    puts senators.senators.map{|sen| [sen.first_name, sen.last_name, sen.email, sen.region, sen.departement ].join(";") unless sen.email.nil?}.compact.to_yaml
    senators.senators.each do |senator|
  #attr_accessible :address, :category, :cell, :company, :country, :fax,
    #:first_name, :infos, :is_active, :is_ceres_member, :last_name, :website,
    #:position, :postal_code, :phone, :emails_attributes, :versions_attributes,
    #:member_id
      c = Contact.new do |contact|
        contact.first_name = senator.first_name
        contact.country = "France"
        contact.company = "Sénat"
        contact.last_name = senator.last_name
        contact.position = senator.title
        contact.category = "Sénateur Français"
        contact.emails.new(address: senator.email) unless senator.email.nil?
      end
      c.save!
      puts "#{c.first_name} #{c.last_name} : #{c.emails.first.address if c.emails.first}"
    end
  end
  #ActiveRecord::Base.connection.increment_open_transactions
  #ActiveRecord::Base.connection.begin_db_transaction
  #at_exit do
    #ActiveRecord::Base.connection.rollback_db_transaction
    #ActiveRecord::Base.connection.decrement_open_transactions
  #end
end
