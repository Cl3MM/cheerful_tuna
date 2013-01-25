require_relative 'boot'
require_relative 'environment'

#every(3.minutes, 'marketpoint.fetch') { Delayed::Job.enqueue MarketPointJob.new }

require "clockwork"

#class MyWorker
  #include Sidekiq::Worker

  #def perform(count)
    #puts "Job ##{count}: Late night, so tired..."
  #end

  #def self.late_night_work
    #10.times do |x|
      #perform_async(x)
    #end
  #end
#end

#class HourlyWorker
  #include Sidekiq::Worker

  #def perform
    #cleanup_database
    #format_hard_drive
  #end
#end

module Clockwork

  every 2.minutes, 'find_and_suspend_outdated_members' do
    Tasks::CronTasks.find_and_suspend_outdated_members
  end
  # Kick off a bunch of jobs early in the morning
  #every 1.day, 'my_worker.late_night_work', :at => '4:30 am' do
    #CronTasks.late_night_work
  #end

  #every 1.hour do
    #HourlyWorker.perform_async
  #end
end
