CheerfulTuna::Application.configure do

  ActsAsTaggableOn.force_lowercase = true

  # Change mail delvery to either :smtp, :sendmail, :file, :test
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              ENVIRONMENT_CONFIG[:mail_server],
    port:                 ENVIRONMENT_CONFIG[:mail_port],
    domain:               ENVIRONMENT_CONFIG[:mail_domain],
    user_name:            ENVIRONMENT_CONFIG[:mail_user_name],
    password:             ENVIRONMENT_CONFIG[:mail_password],
    authentication:       "plain",
    enable_starttls_auto: true,
    ssl:                  true,
    openssl_verify_mode:  'none'
  }
  config.roadie.enabled = true
  # Specify what domain to use for mailer URLs
  config.action_mailer.default_url_options = {host: ENVIRONMENT_CONFIG[:mail_domain]}

  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = true

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  config.action_dispatch.tld_length = 1

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  config.logger = Logger.new( Rails.root.join("log", Rails.env + ".log"))

  # See everything in the log (default is :info)
  config.log_level = :info

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  config.assets.precompile += %w( morris.min.js raphael-min.js mercury.js select2.js bootstrap-datepicker.js jquery-1.7.js )
  config.assets.precompile += %w( contacts.js users.js members.js email_listings.js delivery_requests.js collection_points.js )
  config.assets.precompile += %w( contacts.css members.css email_listings.css delivery_requests.css collection_points.css )
  config.assets.precompile += %w( select2.css jquery.ui.core.css jquery.ui.datepicker.css jquery.ui.slider.css )
  config.assets.precompile += %w( sessions.css invoices.css mailings.css jquery.ui.theme.css mailings.js )
  config.assets.precompile += %w( jquery-timepicker-addon.js jquery-ui-slider-access.js invoices.js)

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5
end
