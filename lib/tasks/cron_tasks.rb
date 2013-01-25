class Tasks::CronTasks

  def self.find_and_suspend_outdated_members
    Member.all.each do |member|
      if member.end_date < Date.today
        member.delay.suspend unless not member.status && member.status.to_sym == :suspended
        member.contacts.each do |contact|
          MemberMailer.delay.notify_membership_expiry(contact.full_name, contact.email_addresses.join(";")).deliver #testing
        end
      end
    end
  end

end
