# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

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
  
  def work_exercise(student_exercise, be_right=false)
    student_exercise.free_response = "blah"
    student_exercise.free_response_confidence = 0
    student_exercise.lock_response_text_on_next_save = true
    student_exercise.save!
    
    exercise = student_exercise.assignment_exercise.topic_exercise.exercise
    correct_choice_index = exercise.correct_choice_index
    num_choices = exercise.num_choices
    
    student_exercise.selected_answer =
      be_right ? 
        correct_choice_index : 
        (0..num_choices-1).to_a.reject{|n| n == correct_choice_index}.first
    
    student_exercise.save!
  end
  
end
