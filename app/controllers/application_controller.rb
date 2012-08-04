class ApplicationController < ActionController::Base
  protect_from_forgery

  def redirect_user!
    if current_user
      flash[:error] = "Sorry, this section is for Members only !"
      redirect_to root_path
    end
  end

  def redirect_member!
    if current_member
      flash[:error] = "Sorry, this section is closed to members"
      redirect_to profile_path
    end
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(Member)
      members_profile_path
    else
      super
    end
  end

  def after_sign_out_path_for(resource)
    if resource.to_s == "member"
      new_member_session_path
    else
      super
    end
  end
end
