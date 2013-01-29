CheerfulTuna::Application.configure do
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.smtp_settings = {
    address:              ENVIRONMENT_CONFIG[:mail_server],
    port:                 ENVIRONMENT_CONFIG[:mail_port],
    domain:               ENVIRONMENT_CONFIG[:mail_domain],
    authentication:       "plain",
    enable_starttls_auto: true,
    user_name:            ENVIRONMENT_CONFIG[:mail_user_name],
    password:             ENVIRONMENT_CONFIG[:mail_password]
  }
  config.roadie.enabled = true
  config.logger = Logger.new(Rails.root.join("log", Rails.env + ".log"), 3, 1*1024*1024 )

  # Specify what domain to use for mailer URLs
  config.action_mailer.default_url_options = {host: ENVIRONMENT_CONFIG[:mail_domain]}

  # Settings specified here will take precedence over those in config/application.rb

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Configure static asset server for tests with Cache-Control for performance
  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=3600"

  # Log error messages when you accidentally call methods on nil
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection    = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :stderr
end
