# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

require 'ost_utilities'

Ost::Application.configure do
  include Ost::Utilities
  # Settings specified here will take precedence over those in config/application.rb

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection    = false

  # Configure static asset server for tests with Cache-Control for performance
  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=3600"

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  ########################################
  # CONFIGURE THE RAILS APPLICATION DOMAIN
  ########################################
  #
  # When our rails application starts under the :development environment, it listens
  # on http://127.0.0.1:3000 (a.k.a. http://localhost:3000).  In the :test environment under
  # Capybara, it listens on http://127.0.0.1 but with a Capybara-assigned port number.
  #
  # According to the HTTP standard, browser redirection should be done with an absolute URL,
  # not a relative path.  This means that if our rails applications thinks its domain is
  # "my.domain.com", redirect URLs will be of the form "my.domain.com/relative/path".
  #
  # When running tests, we need to tell our rails application that its domain is
  # "127.0.0.1" to prevent redirects from taking the Capybara test "browser" to an
  # external URL.  This only affects @javascript-capable browser drivers since
  # :rack_test ignores the domain portion of the URL. 
  config.action_mailer.default_url_options     = { :host => '127.0.0.1' }
  config.action_controller.default_url_options = { :host => '127.0.0.1' }

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :stderr
  
  config.enable_recaptcha = false
  
  config.enable_url_existence_validations = online?
  # config.enable_url_format_validations = false

end

Devise.setup do |config|
  config.timeout_in = 200.years
end
