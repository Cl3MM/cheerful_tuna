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

  desc "Generate member's username"
  task :generate_member_username => :environment do
    Rails.logger.debug "Rake task Generate_member_username called\n" + "*" * 80 + "\n"
    member_usernames = Member.all.map do |c|
      user_name = c.generate_username
      Rails.logger.debug "Member: {id: #{c.id}, company: #{c.company}}: #{user_name}"
      puts "Member: {id: #{c.id}, company: #{c.company}}: #{user_name}"
      [c.company, user_name, SecureRandom.urlsafe_base64[0..14], (c.contacts.first.emails.first.address rescue "")]
    end
    File.open("#{Rails.root}/tmp/usernames.csv",'w') {|f| f.puts(member_usernames.sort.map{|x| x.join(";")}.join("\n"))}
  end

  #desc "Geolocate Collection Point"
  #task geolocate_collection_point: :environment do
    #CollectionPoint.
    #Contact.import_index
  #end

  desc "Update Tire/Elasticsearch index"
  task import_tire_index: :environment do
    Contact.create_search_index
    Contact.import_index
  end

  desc "Create original collection points"
  task create_collection_point: :environment do
    cp_attrs = [ :cp_id, :name, :telephone, :address, :postal_code, :city,
                 :country, :contact_name, :contact_email, :contact_telephone ]
    cps = [ ["FR0002", "Trialp", "+33 4 79 96 41 05", "928 avenue de la houille blanche", "73000", "Chambéry", "France", "", "", ""],
            ["FR0002", "Gensun (Montpellier)", "+33805 23 33 23", "300 rue Rolland Garos, Espace Fréjorgues Ouest", "34130", "Maugio", "France", "", "", ""],
            ["FR0003", "Gensun (Aix en Provence)", "+33805 23 33 23", "Welcome Park - Bât B – Lot N°6, 505 rue Victor Baltard", "13854 ", "Aix-en-Provence", "France", "", "", ""],
            ["FR0005", "Gensun (Pau)", "+33805 23 33 23", "Rue des Bruyères, ZI de Berlanne", "64160", "Morlaas", "France", "", "", ""],
            ["BE0001", "MDU Construction", "+32497219937", "7 rue de la Science", "4530", "Villers-le-Bouillet", "Belgium", "Geoffrey MENTION", "geof@m-duconstruction.be", ""],
            ["SP0002", "Solucciona Energia", "+34699244937", "25 Calle Mayor", "28721", "Redueña", "Spain", "Manuel Camero", "mcamero@solucciona.com", "+34 699244937"],
            ["FR0002", "Gensun (Montpellier)", "+33805 23 33 23", "300 rue Rolland Garos, Espace Fréjorgues Ouest", "34130", "Maugio", "France", "", "", ""],
            ["FR0003", "Gensun (Aix en Provence)", "+33805 23 33 23", "Welcome Park - Bât B – Lot N°6, 505 rue Victor Baltard", "13854 ", "Aix-en-Provence", "France", "", "", ""],
            ["FR0005", "Gensun (Pau)", "+33805 23 33 23", "Rue des Bruyères, ZI de Berlanne", "64160", "Morlaas", "France", "", "", ""],
            ["FR0004", "Gensun (Toulouse)", "+33805 23 33 23", "Z.A.C des Marots, 36 chemin des Sévennes", "31770", "Colomiers", "France", "", "", ""],
            ["FR0006", "Gensun (Lille)", "+33805 23 33 23", "30 avenue de la libération", "59270", "Bailleul", "France", "", "", ""],
            ["DE0001", "SolarBau Süd GmbH", "+49 7022 24 440 - 0", "Lessingstraße 25", "D- 72663", "Großbettlingen", "Germany", "", "", ""],
            ["GR0001", "Silcio S.A.", "+30 2610 242001", "Industrial Area of Patras, Block 35D", "GR-265 00", "Patras", "Greece", "Nikos Papadellis", "n.papadellis@silcio.gr", ""],
            ["SP0001", "Solucciona Energia", "+34918135169", "Júpiter 16 ", "28229", "Villanueva del Pardillo", "Spain", "Fernando Mateo", "fmateo@solucciona.com", "+34 918 135 169"]
    ]
    cps.each do |cp|
      # mapping collection_point attr
      hash = cp.reduce({}) do |h, cpp|
        h[ cp_attrs[cp.find_index(cpp)] ] = ( cpp.strip.blank? ? nil : cpp.strip.gsub(/[\t\n]+|  +/," ").gsub(/  /, " "))
        h
      end
      #ap hash
      if CollectionPoint.where(hash.except(:contact_name, :contact_email, :contact_telephone)).empty? 
        puts "Creating Collection Point #{hash[:name]}"
        if hash[:contact_name]
          puts "Contact key found, creating or finding one"
          puts "Contact.where(company: \"#{hash[:name]}\", first_name: \"#{hash[:contact_name].split(' ').first}\", last_name: \"#{hash[:contact_name].split(' ').last}\", address: \"#{hash[:address]}\", city: \"#{hash[:city]}\")"

          # creating contact if exists
          contact = nil
          #if ( Contact.where( company:        hash[:name],
                             #first_name:     hash[:contact_name].split(' ').first,
                             #last_name:      hash[:contact_name].split(' ').last,
                             #address:        hash[:address],
                             #city:           hash[:city]
                            #).any? )
          if Email.find_by_address(hash[:contact_email]).any?
            contact = Email.find_by_address(hash[:contact_email]).contact
            puts "Contact already exists"
          else
            puts "Contact does not exist, creating it..."
            contact = Contact.new(
              first_name:     hash[:contact_name].split(' ').first,
              last_name:      hash[:contact_name].split(' ').last,
              phone:          hash[:contact_telephone],
              city:           hash[:city],
              address:        hash[:address],
              postal_code:    hash[:postal_code],
              country:        hash[:country],
              company:        hash[:name],
              civility:       "Mr",
              category:       "Collection Point"
            )
            contact.emails.new(address: hash[:contact_email])
            contact.tag_list = "Collection Point"
            contact.update_attribute(:user_id, User.find_by_username("clement").id)
            contact.save!
          end
          contact
        else
          puts "Contactless collection point"
        end
        puts "Creating Collection Point"
        new_cp = hash.except(:contact_name, :contact_email, :contact_telephone)
        new_cp[:status] = "operational"
        collection_point = CollectionPoint.new(new_cp)
        collection_point.contact_ids = [contact.id] if contact
        collection_point.save
      else
        puts "Collection Point already exists: #{hash[:name]}"
      end
    end
  end
end
