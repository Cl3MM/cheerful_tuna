source 'https://rubygems.org'

gem 'rails', '~> 3.2.11'
#, '3.2.3'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

#gem 'sqlite3'
#gem 'thin'
gem 'puma'
gem 'kaminari'
#gem 'will_paginate', '> 3.0'
#gem 'will_paginate-bootstrap'
gem 'simple_form'
gem 'roo'
gem 'nokogiri'
gem 'mysql2'
gem 'irbtools', require: false
gem 'country_select'
gem 'devise'
gem 'vestal_versions', git:'git://github.com/milkfarm/vestal_versions.git'
gem 'tire'
gem 'yaml_db'
gem 'prawn', git: 'git://github.com/prawnpdf/prawn', branch: 'master'
gem 'rmagick'
gem 'carrierwave'
gem 'rqrcode', git: 'http://github.com/whomwah/rqrcode'
gem 'roadie'
gem 'acts-as-taggable-on'
gem 'geocoder'
gem 'recaptcha', :require => 'recaptcha/rails'
gem 'mercury-rails'
gem 'paperclip'
gem 'friendly_id', '~> 4.0.1'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim'
gem "redis", "~> 3.0.1"
#gem 'rack-mini-profiler'

#gem 'thinking-sphinx', '2.0.10'

#gem 'vestal_versions', :git => 'git://github.com/adamcooper/vestal_versions'

# Gems used only for assets and not required
# in production environments by default.
gem 'coffee-rails', '~> 3.2.1'
gem 'less-rails'
gem 'select2-rails'
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'twitter-bootstrap-rails'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'execjs'
  ## fix for TheRubyRacer installation
  #gem 'libv8', '3.11.8.3'
  #gem 'therubyracer', :platform => :ruby
  gem 'therubyracer', '0.10.2', :platforms => :ruby
  gem 'jquery-ui-rails'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :development do
  gem "better_errors"
  gem "binding_of_caller"
end

group :test, :development do
  gem 'rspec-rails' #, :group => [:test, :development]
  gem "letter_opener"
  gem 'pry'
end

group :test do
  gem 'shoulda-matchers'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'capybara', '~> 1.1.0'
  gem 'poltergeist'
  gem 'guard-rspec'
  gem 'spork', '~> 1.0rc'
  gem 'guard-spork'
  gem 'rb-inotify', '~> 0.8.8'
  gem 'database_cleaner'
  gem 'launchy'
  #gem 'vcr'
  #gem 'fakeweb'
  gem 'capybara-mechanize'
end

