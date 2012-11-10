require 'rubygems'
require 'spork'
require 'capybara/rspec'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  ###########################################################
  # FORCE ALL THREADS TO SHARE ONE CONNECTION TO THE DATABASE
  ###########################################################
  #
  # Database transactions are determined on a per-connection basis.  Each thread (or
  # process) accessing the database establishes its own connection.
  #
  # There are two components to Capybara scenarios: "scenario steps" and the "browser".
  #
  # When Capybara runs using the :rack_test "browser", everything runs in one thread.
  # This means that the scenario steps and browser share the same database connection
  # and therefore can see each other's uncommitted database transactions. For example,
  # if a scenario step programatically adds data to the database:
  #     create_new_item(:name => "Thingy")
  # then that change is visible to the browser:
  #     visit '/item/1'
  #
  # However, when Capybara runs using any other "broswer" than :rack_test, is launches
  # the browser in a separate thread.  Now the scenario steps and browser have separate
  # database connections and therefore do NOT see each other's uncommitted transactions.
  # In the example above, the browser would get a "page not found" error because item
  # 'Thingy' doesn't exist in its database connection.
  #
  # The following code (plus a snippet in the Spork.for_each block) causes all database
  # users to share the same connection.
  #
  # IMPORTANT NOTE:
  #
  # This will NOT protect against threading issues in the scenarios themselves.  For
  # example, you have the steps:
  #    When I click on then button to create item in database 
  #    Then there should be an item in the database
  # you are introducing a potential race condition.  The second step needs to block on
  # something that tells it that the browser in the first step actually finished its
  # interactions with the database.
  #
  # For details, see:
  #   http://rubydoc.info/github/jnicklas/capybara/master#The_DSL
  #   http://blog.plataformatec.com.br/2011/12/three-tips-to-improve-the-performance-of-your-test-suite/
  class ActiveRecord::Base
    mattr_accessor :shared_connection
    @@shared_connection = nil
  
    def self.connection
      @@shared_connection || retrieve_connection
    end
  end

  ####################################
  # SET THE DATABASE ROLLBACK STRATEGY
  ####################################
  #
  # As long as all threads share the same connection and use_transactional_fixtures
  # is true, we can simply use DatabaseCleaner's :transaction strategy to rollback 
  # changes made during scenarios.  Otherwise we must use :truncation.
  #
  # To ensure we start with a empty database before the first scenario, we use
  # :truncation initially.
  DatabaseCleaner.clean_with :truncation # clean once to ensure clean slate
  DatabaseCleaner.strategy = :transaction
  
  ########################################
  # CONFIGURE THE RAILS APPLICATION DOMAIN
  ########################################
  # This is done in config/environments/test.rb
  
  #####################################################
  # SET CAPYBARA DEFAULT AND JAVASCRIPT BROWSER OPTIONS
  #####################################################
  #
  # For scenarios tagged with @javascript, Capybara launches a Capybara.javascript_driver "browser",
  # which must be one which supports the execution of javascript (:webkit, :poltergeist, or :selenium).
  # Otherise, Capybara launches a Capybara.default_driver "broswer".
  #
  # The normal values are:
  #   default_driver    = :rack_test
  #   javascript_driver = :selenium
  #
  # Because of the precautions taken above w.r.t. connections, transactions and domains, we can freely mix and
  # match default and javascript drivers.
  # Capybara.javascript_driver = :webkit
  # Capybara.default_driver    = :rack_test  ## NOTE: currently all scenarios assume @javascript, so :rack_test will cause problems
  Capybara.javascript_driver = :webkit
  Capybara.default_driver    = :webkit
  # Capybara.javascript_driver = :selenium
  # Capybara.default_driver    = :selenium
  # Capybara.javascript_driver = :poltergeist
  # Capybara.default_driver    = :poltergeist

  #############################
  # OTHER CONFIGURATION OPTIONS
  #############################

  # Capybara defaults to XPath selectors rather than Webrat's default of CSS3. In
  # order to ease the transition to Capybara we set the default here. If you'd
  # prefer to use XPath just remove this line and adjust any selectors in your
  # steps to use the XPath syntax.
  Capybara.default_selector = :css
  
  # Turn off automatic screencapture when scenario fails
  Capybara::Screenshot.autosave_on_failure = false

  # This causes capybara #has_css? and #find selectors to return quickly
  # in the event of a failure
  Capybara.default_wait_time = 0.01;
  
  RSpec.configure do |config|
    # ## Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    #config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    # Run specs in random order to surface order dependencies. If you find an
    # order dependency and want to debug it, you can fix the order by providing
    # the seed, which is printed after each run.
    #     --seed 1234
    config.order = "random"
  end

end

Spork.each_run do
  # This code will be run each time you run your specs.

  ###########################################################
  # FORCE ALL THREADS TO SHARE ONE CONNECTION TO THE DATABASE
  ###########################################################
  # See above for details.
  ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

end
