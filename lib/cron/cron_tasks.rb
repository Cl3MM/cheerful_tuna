class Cron::CronTasks

  def self.daily_suspend_and_email_due_members
    Member.all.each do |member|
      if (not member.suspended?) && (member.end_date < Date.today)
        member.delay.suspend!
        member.contacts.each do |contact|
          MemberMailer.delay.notify_membership_expiry(contact.full_name, contact.email_addresses) #to_a?
        end
      end
    end
  end

end
