class Joomla::UsersController < ApplicationController
  before_filter :authorize_member, except: [:new, :create, :destroy]

  def index
    @member = current_member
  end
  def new
  end

  def edit
    @member = current_member
  end
  def create
    user = JoomlaUser.find_by_username(params[:username])
    Rails.logger.debug "*" * 100
    Rails.logger.debug "User: #{user}"
    if user && user.authenticate(params[:password])
      @member = user.find_tuna_member
      if params[:remember_me]
        cookies.permanent[:auth_token] = @member.auth_token
      else
        cookies[:auth_token] = @member.auth_token
      end unless @member.nil?
      redirect_to joomla_profile_path, notice: "Logged in!"
    else
      flash.now.alert = "Email or password is invalid"
      render "new"
    end
  end

  def destroy
    cookies.delete(:auth_token)
    redirect_to joomla_login_path, notice: "Logged out!"
  end
end
