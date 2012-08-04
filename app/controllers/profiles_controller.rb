class ProfilesController < ApplicationController
  before_filter :redirect_user!
  before_filter :authenticate_member!
  def index
  end
end

