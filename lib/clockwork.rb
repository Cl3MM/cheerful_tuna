
module Clockwork

  def prout
    puts "*" * 100 + "\nprout"
    Rails.logger.debug "*" * 100 + "\nprout"
  end

  every 1.minute, 'find_and_suspend_outdated_members' do
  #every 1.day, 'find_and_suspend_outdated_members', at: "00:10" do
    Cron::CronTasks.daily_suspend_and_email_due_members
  end

end
