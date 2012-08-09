require 'test_helper'

class PercentSchedulerTest < ActiveSupport::TestCase

  def test_basic  
    
    # Lay out the question URLs to use in each topic in each assignment plan
      
    ap_defs = [
      [ # assignment plan 1
        ["q.a.1","q.a.2","q.a.3","q.a.4","q.a.5","q.a.6"] # topic a
      ],
      [ # assignment plan 2
        ["q.b.1","q.b.2","q.b.3","q.b.4"], # topic b
        ["q.c.1","q.c.2","q.c.3","q.c.4","q.c.5","q.c.6"] # topic c
      ],
      [ # assignment plan 3
        ["q.d.1","q.d.2","q.d.3","q.d.4","q.d.5","q.d.6","q.d.7","q.d.8","q.d.9","q.d.10"]
      ]
    ]    
    
    # Create the learning plan, then iterate through the definitions
    # above to create the assignment plans
    
    lp = FactoryGirl.create(:learning_plan)
    
    ap_defs.each_with_index do |ap_def, ii|
      ap = FactoryGirl.create(:assignment_plan, 
                              :starts_at => Time.now + ii.days,
                              :learning_plan => lp)

      topic_defs = ap_def
      
      topic_defs.each do |topic_def|
        
        apt = FactoryGirl.create(:assignment_plan_topic,
                                 :assignment_plan => ap)

        topic_def.each do |exercise_def|
          te = FactoryGirl.create(:topic_exercise,
                                  :topic => apt.topic)
          te.update_url!(exercise_def)
        end
      end
    end
    
    # Make a scheduler

    scheduler = PercentScheduler.new(:schedules => [[{:percent => 50, :tags => 'E1'}, 
                                                     {:percent => 30, :tags => 'E2'}, 
                                                     {:percent => 20, :tags => 'E3, howdy'}]])
    
    cohort = FactoryGirl.create(:cohort,
                                :klass => lp.klass)

    # Build up the assignments.  They must be saved after making them so that
    # the next assignment build can know what has been assigned.
    
    assignments = [
      scheduler.build_assignment(lp.assignment_plans(true)[0], cohort).tap{|a| a.save!},
      scheduler.build_assignment(lp.assignment_plans(true)[1], cohort).tap{|a| a.save!},
      scheduler.build_assignment(lp.assignment_plans(true)[2], cohort).tap{|a| a.save!}
    ]

    # Here are the URLs/tags that we expect in each assignment

    expected = [
      [ ["q.a.1", 'e1'], ["q.a.2", 'e1'], ["q.a.3", 'e1'] ],
      [ ["q.b.1", 'e1'], ["q.b.2", 'e1'], ["q.c.1", 'e1'], ["q.c.2", 'e1'], ["q.c.3", 'e1'], ["q.a.4", 'e2'] ],
      [ ["q.d.1", 'e1'], ["q.d.2", 'e1'], ["q.d.3", 'e1'], ["q.d.4", 'e1'], ["q.d.5", 'e1'], ["q.b.3", 'e2'], ["q.c.4", 'e2'], ["q.a.5", ['e3', 'howdy'] ]]
    ]

    # Make sure expected == actual

    assignments.each_with_index do |assignment, ii|
      assignment.assignment_exercises.each_with_index do |ae, jj|
        assert_equal expected[ii][jj][0], ae.topic_exercise.exercise.url
        [expected[ii][jj][1]].flatten.each do |expected_tag| 
          assert ae.has_tag?(expected_tag)
        end 
      end
    end
    
  end

end
