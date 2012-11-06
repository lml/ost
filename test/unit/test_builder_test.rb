# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

require 'test_helper'

class TestBuilderTest < ActiveSupport::TestCase

  def test_basic  
    # Lay out the question URLs to use in each topic in each assignment plan
      
    ap_defs = [
      [ # midterm 1
        ["q.b.1","q.b.2","q.b.3","t.b.4"], # topic a
        ["t.c.1","q.c.2","q.c.3","q.c.4","q.c.5","t.c.6"], # topic b
        ["q.d.1","q.d.2","q.d.3","q.d.4","q.d.5","t.d.6","t.d.7","t.d.8","t.d.9","q.d.10"] # topic c
      ]
    ]    
    
    num_to_use = [0, 2, 3]
    
    # Create the learning plan, then iterate through the definitions
    # above to create the assignment plans
    
    lp = FactoryGirl.create(:learning_plan)
    
    cohort = FactoryGirl.create(:cohort,
                                :klass => lp.klass)
    
    other_test = FactoryGirl.create(:assignment, :cohort => cohort)
    
    Rails.configuration.fake_json_content = true
    
    ap_defs.each_with_index do |ap_def, ii|
      ap = FactoryGirl.create(:assignment_plan, 
                              :starts_at => Time.now + 1.day + ii.days,
                              :ends_at => Time.now + 4.days + ii.days,
                              :learning_plan => lp,
                              :is_test => true,
                              :exercise_tags => 'midterm')

      topic_defs = ap_def
      
      topic_defs.each_with_index do |topic_def, tt|
        
        apt = FactoryGirl.create(:assignment_plan_topic,
                                 :assignment_plan => ap,
                                 :num_exercises_to_use => num_to_use[tt])

        topic_def.each do |exercise_def|
          te = FactoryGirl.create(:topic_exercise,
                                  :topic => apt.topic, 
                                  :reserved_for_tests => !!exercise_def.match("t"))
          te.update_url!(exercise_def)
          
          # Fake one test exercise having already been assigned
          if "t.d.6" == exercise_def
            FactoryGirl.create(:assignment_exercise, :topic_exercise => te, :assignment => other_test)
          end
        end
      end
    end
    
    Rails.configuration.fake_json_content = false
                                
    # Build up the assignments.  They must be saved after making them so that
    # the next assignment build can know what has been assigned.
    #debugger
    
    test_assignment = TestBuilder.build_assignment(lp.assignment_plans(true)[0], cohort).tap{|a| a.save!}

    # Here are the URLs/tags that we expect in each assignment

    expected =  [ ["t.c.1", 'midterm'], ["t.c.6", 'midterm'], ["t.d.7", 'midterm'], ["t.d.8", 'midterm'], ["t.d.9", 'midterm'] ]

    # Make sure expected == actual

    test_assignment.assignment_exercises.each_with_index do |ae, jj|
      assert_equal "http://" + expected[jj][0], ae.topic_exercise.exercise.url
      assert_equal jj+1, ae.number
      [expected[jj][1]].flatten.each do |expected_tag| 
        assert ae.has_tag?(expected_tag)
      end 
    end
    
  end

end
