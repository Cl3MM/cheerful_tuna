class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_member
#    @current_member ||= Member.find_by_id(session[:member_id]) if session[:member_id]
    @current_member ||= Member.find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
  end
  helper_method :current_member

  def authorize_member
    redirect_to joomla_login_url, alert: "Not authorized" if current_member.nil?
  end

  def redirect_user!
    if current_user #and not current_member
      flash[:error] = "Sorry, this section is for Members only !"
      redirect_to root_path
    end
  end

  def authorize_admin!
    redirect_to login_url, alert: "Not authorized" unless current_user.is_admin?
  end

  #def redirect_member!
    #if current_member and not current_user
      #flash[:error] = "Sorry, this section is closed to members"
      #redirect_to members_profile_path
    #end
  #end

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
