# encoding: UTF-8

require 'awesome_print'

namespace :stats do

  desc "Generate user statistics"
  task :contacts, [:date, :range] => :environment do |t, args|
    args.with_defaults(range: "week", date: Time.now)
    begin
      date = Date.parse(args.date)
    rescue
      date = Time.now
    end

    start_date = args.range == "month" ? date.beginning_of_month : date.beginning_of_week
    end_date   = args.range == "month" ? date.end_of_month : date.end_of_week
    date_format = args.range == "month" ? "%Y-%m" : "%Y-%m-%d"
    date_print_format = args.range == "month" ? "%b" : "%d/%m"

    #@contacts_stats = Contact.find( :all, select: "DATE_FORMAT(contacts.created_at, '%Y-%m-%d') as day, count(contacts.user_id) as count, users.username", group: "DATE_FORMAT(contacts.created_at, '%Y-%m-%d'), user_id", conditions: ["contacts.created_at >= ?", 4.months.ago], joins: "LEFT JOIN `users` ON users.id = contacts.user_id")

    @contacts_stats = Contact.find(
      :all,
      select: "DATE_FORMAT(contacts.created_at, '#{date_format}') as day, count(contacts.user_id) as count, users.username", 
      group: "day, user_id",
      conditions: ["contacts.created_at BETWEEN ? AND ?", start_date, end_date],
      joins: "LEFT JOIN `users` ON users.id = contacts.user_id")

    #puts Contact.find(
      #:all,
      #select: "DATE_FORMAT(contacts.created_at, '%Y-%m-%d') as day, count(contacts.user_id) as count, users.username", 
      #group: "DATE_FORMAT(contacts.created_at, '%Y-%m-%d'), user_id",
      #conditions: ["contacts.created_at BETWEEN ? AND ?", start_date, end_date],
      #joins: "LEFT JOIN `users` ON users.id = contacts.user_id").to_sql

      #conditions: ["contacts.created_at >= ?", Time.now.beginning_of_week],

      @users = @contacts_stats.map(&:username).uniq.sort
      @days = @contacts_stats.map(&:day).uniq.sort

      @contact_stats_by_user = @contacts_stats.group_by{|c| c.username}

      ### x.map{|c| {c.day =>  [c.username, c.count]} }
      remap = @contacts_stats.map{|c| {day: c.day, user: c.username, count: c.count} }

      output = Hash.new(0)
      remap.each do |item|
        if output.has_key? item[:day]
          output[item[:day]].update({item[:user] => item[:count]})
        else
          output[item[:day]] = {item[:user] => item[:count]}
        end
      end

      puts "Week #{start_date.strftime("%W")}: #{start_date} to #{end_date}" if args.range == "week"

      to_print = ["|".ljust(12)]
      begin
        to_print << output.keys.map{|d| Date.parse(d).strftime(date_print_format).center(7)}.join('|')
      rescue
        to_print << output.keys.map{|d| Date.parse("#{d}-01").strftime(date_print_format).center(7)}.join('|')
      end
      to_print << "Total".center(7) + "|\n"

      @users.each do |user|
        out = [" #{user.capitalize.ljust(10)}"]
        sum = 0
        output.keys.sort.each do |day|
          count_value = output[day].has_key?(user) ? output[day][user] : 0
          out << "#{count_value.to_s.center(7)}"
          sum += count_value
        end
        to_print << "#{out.join('|')}|#{sum.to_s.rjust(7)}|\n"
      end

      puts to_print.join("|")
  end
  desc "Find contacts with empty country"
  task :void_countries => :environment do
    File.open("#{Rails.root}/tmp/empty_countries.txt", "w")do |f|
      f.write(Contact.where(country: "").map{|c| "http://tuna.ceres-recycle.org/contacts/#{c.id}"}.join("\n"))
    end
    File.open("#{Rails.root}/tmp/empty_countries.yml", "w")do |f|
      f.write(Contact.where(country: "").to_yaml)
    end
  end

  desc "Generate user statistics"
  task :kill, [:date, :range] => :environment do |t, args|
    args.with_defaults(range: "week", date: Time.now)
    begin
      date = Date.parse(args.date)
    rescue
      date = Time.now
    end
  end

  desc "Send test emails"
  task :send_test_emails => :environment do
    list = [ {name: "Clement Roullet", email: "clement.roullet@gmail.com"}, {name: "Clement Roullet", email: "clement.roullet@ceres-recycle.org" }]
    list.each do |contact|
      puts "Sending email to Mr #{contact[:name]} <#{contact[:email]}>"
      MemberMailer.generic_send(contact[:name], contact[:email]).deliver
    end
  end
end
