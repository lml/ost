# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :course do
    name "MATH 101: #{Faker::Lorem.words(2).join(' ')}"
    description Faker::Lorem::paragraphs(1).join
    typically_offered "Fall Semester"
    organization
  end
end
