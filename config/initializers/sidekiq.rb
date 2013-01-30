Sidekiq.configure_server do |config|
  #config.redis = { :url => 'redis://redis.example.com:7372/12', :namespace => 'mynamespace' }
  config.redis = { url: "redis://#{ENVIRONMENT_CONFIG[:redis_socket]}", namespace: "#{Rails.env}-#{Rails.application.class.to_s.downcase}" }

  database_url = ENV['DATABASE_URL']
  if(database_url)
    ENV['DATABASE_URL'] = "#{database_url}?pool=30"
    ActiveRecord::Base.establish_connection
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{ENVIRONMENT_CONFIG[:redis_socket]}", namespace: "#{Rails.env}-#{Rails.application.class.to_s.downcase}" }
end
