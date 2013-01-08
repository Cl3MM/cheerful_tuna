#$redis = Redis.new(host: 'localhost', port: 6379)
#$redis = Redis.new(host: ENVIRONMENT_CONFIG[:redis_socket].split(':').first, port: ENVIRONMENT_CONFIG[:redis_socket].split(':').last)
$redis = Redis.new host: ENVIRONMENT_CONFIG[:redis_socket].split(':').first,
                   port: ENVIRONMENT_CONFIG[:redis_socket].split(':').last
