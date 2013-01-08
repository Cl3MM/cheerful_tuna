Sidekiq.configure_server do |config|
  #config.redis = { :url => 'redis://redis.example.com:7372/12', :namespace => 'mynamespace' }
  config.redis = { url: "redis://#{ENVIRONMENT_CONFIG[:redis_socket]}", namespace: "#{Rails.env}-#{Rails.application.class.to_s.downcase}" }
end

Sidekiq.configure_client do |config|
  config.redis = { :url => "redis://#{ENVIRONMENT_CONFIG[:redis_socket]}", :namespace => "#{Rails.env}-#{Rails.application.class.to_s.downcase}" }
end
