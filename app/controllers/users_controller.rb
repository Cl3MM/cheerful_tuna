class UsersController < ApplicationController
  before_filter :authenticate_user!

  def generate_chart
    date = (Date.parse(params[:date]) rescue Date.today)
    timeframe = (["week", "month"].include?(params[:timeframe]) ? params[:timeframe] : "month")
    #unless ENV['RAILS_ENV'] = "production" or Rails.env.production?
      @stats  = User.contacts_per_user_stats(date, timeframe)
    #else
      #@stats  = User.contacts_per_user_stats(date, timeframe)
    #end
    if timeframe == "week"
      @stats[:prev_date] = date.prev_week
      @stats[:next_date] = date.next_week
      @stats[:title] = "Week ##{date.strftime("%W")} : #{date.beginning_of_week.strftime("%B, %d")} to #{date.end_of_week.strftime("%d, %Y")}"
    else timeframe == "month"
      @stats[:prev_date] = date.prev_month
      @stats[:next_date] = date.next_month
      @stats[:title] = date.strftime("%B %Y")
    end
    respond_to do |format|
      format.json { render json: @stats.to_json }
    end
  end

  def statistics
#    unless ENV['RAILS_ENV'] = "production" or Rails.env.production?
      @date = Date.today
      @monthly_stats = User.contacts_per_user_stats
      @weekly_stats  = User.contacts_per_user_stats(@date, "week")
#    else
#      @date = "2012-06-26".to_date
#      @monthly_stats = User.contacts_per_user_stats(@date)
#      @weekly_stats  = User.contacts_per_user_stats(@date, "week")
#    end
    @contacts_per_day = User.average_contact_per_day
    @contacts_per_month = User.average_contact_per_month(@date)

    respond_to do |format|
      format.html # index.html.erb
    end
  end
end
