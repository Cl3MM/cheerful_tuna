class UsersController < ApplicationController
  before_filter :authenticate_user!

  def generate_chart
    date = (Date.parse(params[:date]) rescue Date.today)
    timeframe = (["week", "month"].include?(params[:timeframe]) ? params[:timeframe] : "month")

    Rails.logger.debug "params[:timeframe] #{params[:timeframe]}"
    Rails.logger.debug "timeframe #{timeframe}"
    Rails.logger.debug "date: #{date}"

    unless ENV['RAILS_ENV'] = "production" or Rails.env.production?
      Rails.logger.debug "Displaying statistics of the day"
      @stats  = User.contacts_per_user_stats(date, timeframe)
    else
      Rails.logger.debug "Displaying test statistics ..."
      @stats  = User.contacts_per_user_stats(date, timeframe)
      #@stats  = User.contacts_per_user_stats("2012-06-26".to_date, timeframe)
    end
    if timeframe == "week"
      @stats[:prev_date] = date.prev_week
      @stats[:next_date] = date.next_week
      @stats[:title] = "Week ##{date.strftime("%W")} : #{date.beginning_of_week.strftime("%B, %d")} to #{date.end_of_week.strftime("%d, %Y")}"
    else timeframe == "month"
      @stats[:prev_date] = date.prev_month
      @stats[:next_date] = date.next_month
      @stats[:title] = date.strftime("%B %Y")
    end
    Rails.logger.debug "params: #{params}"
    Rails.logger.debug "stats: #{@stats}"
    respond_to do |format|
      format.json { render json: @stats.to_json }
    end
  end

  def statistics
    unless ENV['RAILS_ENV'] = "production" or Rails.env.production?
      @date = Date.today
      @monthly_stats = User.contacts_per_user_stats
      @weekly_stats  = User.contacts_per_user_stats(@date, "week")
    else
      @date = "2012-06-26".to_date
      @monthly_stats = User.contacts_per_user_stats(@date)
      @weekly_stats  = User.contacts_per_user_stats(@date, "week")
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end
end
