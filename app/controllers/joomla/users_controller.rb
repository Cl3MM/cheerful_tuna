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
      session[:member_id] = @member.id unless @member.nil?
      Rails.logger.debug "Tuna member company: #{user.find_tuna_member().company}"
      redirect_to joomla_profile_path, notice: "Logged in!"
    else
      flash.now.alert = "Email or password is invalid"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to joomla_login_path, notice: "Logged out!"
  end
end
