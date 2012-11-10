# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :course do
    sequence(:name)                 {|n| "AutoGen Course Name #{n}"}
    description                     Faker::Lorem::paragraphs(1).join
    sequence(:typically_offered)    {|n| "AutoGen Typically Offered #{n}"}
    organization
  end
end
