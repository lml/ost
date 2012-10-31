# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :response_time do
    response_timeable_id 1
    response_timeable_type "MyString"
    event "MyString"
    note "MyString"
    page "MyString"
  end
end
