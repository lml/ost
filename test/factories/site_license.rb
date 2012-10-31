# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :site_license do
    body Faker::Lorem::paragraphs(7).join("<p>")
    sequence(:title)  {|n| "Terms of Use (#{n})"}
  end
end
