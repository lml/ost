ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  
  def travel_to(time_string, time_zone_string)
    new_time_in_zone = TimeUtils.timestr_and_zonestr_to_utc_time(time_string, time_zone_string)
    Timecop.travel(new_time_in_zone)    
  end
  
  
end
