require 'test_helper'
include Ost::Cron

class Scenario1Test < ActiveSupport::TestCase
  
  test 'number_of_emails_for_assignment_due_feedback' do
    org = FactoryGirl.create(:organization, :default_time_zone => 'Central Time (US & Canada)')
    course = FactoryGirl.create(:course, :organization => org)    
    
    klass = FactoryGirl.create(:klass)
    klass.time_zone = 'Central Time (US & Canada)'
    klass.start_date = Chronic.parse("Aug 1, 2012 9:00 AM")
    klass.end_date = Chronic.parse("Dec 15, 2012 5:00 PM")
    klass.save!
    
    learning_plan = klass.learning_plan
    topic = FactoryGirl.create(:topic, :learning_plan => learning_plan)
    te = TopicExercise.new(:topic => topic)
    te.update_url!("http://quadbase.org/questions/q561v2")
    
    assignment_plan = FactoryGirl.create(:assignment_plan, :learning_plan => learning_plan, :is_ready => true)
    assignment_plan.starts_at = "Aug 1, 2012 9:00 AM"
    assignment_plan.ends_at = "Aug 2, 2012 9:00 AM"
    assignment_plan.topics << topic
    assignment_plan.save
    
    FactoryGirl.create(:cohort, :klass => klass)

    schedules_by_cohort = [
      # Cohort 1
      [
        [{:percent => 100, :tags => "beta"}]
      ],
      # Cohort 2
      [
        [{:percent => 100, :tags => "beta"}]
      ]
    ]

    klass.cohorts(true).each_with_index do |cohort,cc|
      PercentScheduler.create(:learning_condition => cohort.learning_condition, :schedules => schedules_by_cohort[cc] )
      cohort.learning_condition.feedback_conditions.destroy_all
      BasicFeedbackCondition.create(:learning_condition => cohort.learning_condition,
                                    :label_regex => '.*',
                                    :is_feedback_required_for_credit => true,
                                    :can_automatically_show_feedback => false,
                                    :availability_event => BasicFeedbackCondition::AvailabilityEvent::ASSIGNMENT_DUE,
                                    :availability_opens_option => BasicFeedbackCondition::AvailabilityOpensOption::DELAY_AFTER_EVENT,
                                    :availability_opens_delay_days => 7)
    end
    
    s1 = FactoryGirl.create(:student, :section => klass.sections.first, :cohort => klass.cohorts.first)
    s2 = FactoryGirl.create(:student, :section => klass.sections.first, :cohort => klass.cohorts.last)
    
    u1 = s1.user
    u2 = s2.user
    
    travel_to("Aug 1, 2012 9:00 AM", klass.time_zone)

    # AssignmentPlan.build_and_distribute_assignments
    Ost::Cron::execute_cron_jobs
    
    assert_equal 0, ScheduledNotification.count

    StudentAssignment.create(:student_id => s1.id, 
                             :assignment_id => s1.cohort.assignments.first)
    
    work_it(s1.student_assignments.first.student_exercises.first)
    
    assert_equal 0, ScheduledNotification.count
    
    travel_to("Aug 8, 2012 9:00 AM", klass.time_zone)
    
    Ost::Cron::execute_cron_jobs
    
    travel_to("Aug 9, 2012 9:00 AM", klass.time_zone)
    
    assert_difference 'ActionMailer::Base.deliveries.count', 1 do
      Ost::Cron::execute_cron_jobs
    end

    travel_to("Aug 10, 2012 9:00 AM", klass.time_zone)
    
    assert_difference 'ActionMailer::Base.deliveries.count', 0 do
      Ost::Cron::execute_cron_jobs
    end    
        
  end
  
  def work_it(student_exercise)
    student_exercise.free_response = "blah"
    student_exercise.free_response_confidence = 0
    student_exercise.lock_response_text_on_next_save = true
    student_exercise.save!
    student_exercise.selected_answer = 0
    student_exercise.save!
  end
  
  # test "the truth" do
  #   assert true
  # end
end
