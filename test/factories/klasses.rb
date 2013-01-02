# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :klass do
    course
    open_date   Time.now - 1.week
    start_date  Time.now
    end_date    Time.now + 3.months
    close_date  Time.now + 3.months + 1.week
    time_zone   "Central Time (US & Canada)"
    association :creator, factory: :user
  end
end
