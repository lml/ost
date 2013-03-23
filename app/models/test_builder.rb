# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

require 'ost_utilities'

class TestBuilder
  
  include Ost::Utilities
  
  # TODO instead of taking a cohort this could take a cohort or a study
  # result would still be an assignmnent, but if the assignment is for a study
  # it could have separate properties, different consent, etc
  def self.build_assignment(assignment_plan, cohort)
    raise IllegalOperation if !assignment_plan.is_test
    
    klass_tags = assignment_plan.learning_plan.test_exercise_tags
    tags = TestBuilder.new.merge_delimited_strings(",", assignment_plan.tag_list.join(","), klass_tags)
    
    assignment = Assignment.new(:cohort => cohort, :assignment_plan => assignment_plan)
    
    apts = assignment_plan.assignment_plan_topics      
    
    apts.each do |apt|
      topic = apt.topic
      
      # Get test exercises that haven't been assigned, then take the specified 
      # number of them

      topic_exercises = topic.topic_exercises.for_tests
      topic_exercises.reject!{|te| te.assigned_in_cohort?(cohort)}
      topic_exercises = topic_exercises.take( apt.num_exercises_to_use || 0 )
      
      topic_exercises.each do |topic_exercise|
        assignment.add_topic_exercise(topic_exercise, tags)
      end        
    end    
    
    assignment
  end
  
end