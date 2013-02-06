class MembershipObserver < ActiveRecord::Observer
  observe :subscription

  def after_create(subscription)
    if user.purchased_membership?
      GreetingMailer.welcome_and_thanks_email(user).deliver
    else
      GreetingMailer.welcome_email(user).deliver
    end
  end
end
