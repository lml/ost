# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

# Read about factories at https://github.com/thoughtbot/factory_girl

# IMPORTANT!!! because a student assignment has an after_create that makes student_exercises
# try to just get student_exercises that way, not using the below (which probably won't work
# with an "already taken" error)

FactoryGirl.define do
  factory :student_exercise do
    assignment_exercise 
    student_assignment { |instance| Factory(:student_assignment, :assignment => instance.assignment_exercise.assignment) }
  end
end
