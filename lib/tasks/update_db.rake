# encoding: UTF-8

require 'rubygems'
require 'roo'
require 'nokogiri'
require 'digest/md5'
require 'csv'
require 'ap'

namespace :udb do
  desc "Reset Database"
  task :reset => :environment do
    # RAILS_ENV=test ||
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
  end
end
