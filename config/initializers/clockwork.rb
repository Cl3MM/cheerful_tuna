class ClockWorkLogger < Logger
  def format_message(level, time, progname, msg)
    "#{time.to_s(:db)} #{level.ljust(8)} -- #{msg}\n"
  end
end

Clockwork.configure do |config|
  config[:logger] = ClockWorkLogger.new("#{Rails.root}/log/cron_#{Rails.env}.log", 3, 2 * 1024 * 1024)
end
