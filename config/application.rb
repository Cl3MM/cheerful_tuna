require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

file = File.read(File.expand_path('../tuna.yml', __FILE__))
ENVIRONMENT_CONFIG                      = YAML.load(file)
ENVIRONMENT_CONFIG.merge! ENVIRONMENT_CONFIG.fetch(Rails.env, {})
ENVIRONMENT_CONFIG.symbolize_keys!

COUNTRIES                               = ENVIRONMENT_CONFIG[:countries]
DELIVERY_REQUESTS_REASON_OF_DISPOSAL    = ENVIRONMENT_CONFIG[:delivery_requests_reason_of_disposal]
DELIVERY_REQUESTS_MODULES_CONDITION     = ENVIRONMENT_CONFIG[:delivery_requests_modules_condition]
DELIVERY_REQUESTS_TECHNOLOGIES          = ENVIRONMENT_CONFIG[:delivery_requests_technologies].symbolize_keys!
DELIVERY_REQUESTS_STATUS                = ENVIRONMENT_CONFIG[:delivery_requests_status].symbolize_keys!
COLLECTION_POINTS_STATUS                = ENVIRONMENT_CONFIG[:collection_points_status].symbolize_keys!
CERES_CONTACT_CONFIG                    = ENVIRONMENT_CONFIG[:ceres_contacts].symbolize_keys!
MEMBERS_STATUS                          = ENVIRONMENT_CONFIG[:members]["status"].symbolize_keys!
SUBSCRIPTIONS_STATUS                    = ENVIRONMENT_CONFIG[:subscriptions]["status"].symbolize_keys!
MEMBERS_DOCUMENTS                       = ENVIRONMENT_CONFIG[:members]["documents"].symbolize_keys!
MEMBERS_MEMBERSHIP_DOCUMENTS            = ENVIRONMENT_CONFIG[:members]["membership_documents"].symbolize_keys!

# Fix for error: ActiveModel::MassAssignmentSecurity::Error: Can't mass-assign protected attributes: modifications, number, user
module VestalVersions
  # The ActiveRecord model representing versions.
  class Version < ActiveRecord::Base
    attr_accessible :modifications, :number, :user
  end
end

module CheerfulTuna
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.autoload_paths +=  %W(#{config.root}/lib)
    config.autoload_paths +=      %W(#{config.root}/app/concerns)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    #config.active_record.observers = :cacher, :garbage_collector, :forum_observer
    config.active_record.observers = :membership_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'Paris'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    config.active_record.whitelist_attributes = true

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.1'
  end
end
