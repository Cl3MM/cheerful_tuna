class Joomla::UsersController < ApplicationController
  before_filter :authorize_member, except: [:new, :create, :destroy]

  def index
  end
  def new
  end

  def create
    session[:member_id] = nil
    user = JoomlaUser.find_by_username(params[:username])
    Rails.logger.debug "*" * 100
    Rails.logger.debug "User: #{user}"
    if user && user.authenticate(params[:password]) and 
      session[:member_id] = user.find_tuna_member
      Rails.logger.debug "User: #{user.find_tuna_member().company}"
      redirect_to joomla_profile_path, notice: "Logged in!"
    else
      flash.now.alert = "Email or password is invalid"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Logged out!"
  end
end
