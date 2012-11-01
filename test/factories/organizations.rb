# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

# Read about factories at https://github.com/thoughtbot/factory_girl



FactoryGirl.define do
  factory :organization do
    name "Organization #{SecureRandom.random_number(1000000)}"
    default_time_zone "Central Time (US & Canada)"
  end
end
