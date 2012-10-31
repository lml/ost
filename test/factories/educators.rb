# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :educator do
    klass
    user
    is_instructor false
    is_teaching_assistant false
    is_grader false
  end
end
