class PercentScheduler < ActiveRecord::Base
  store :settings, accessors: [:schedules]
  
  attr_accessible :learning_condition_id, :settings
  
  # TODO this should be build_assignment and return an assignment
  def build_student_assignments(this_assignment_plan, cohort)
    learning_plan = this_assignment_plan.learning_plan
    all_assignment_plans = learning_plan.assignment_plans
    this_assignment_plan_number = all_assignment_plans.index{|ap| ap.id == this_assignment_plan.id}
    
    schedule_number = this_assignment_plan_number % schedules.size
    schedule = schedules[schedule_number]
    
    max_num_assignment_exercises = this_assignment_plan.max_num_exercises
    
    current_assignment_plan = this_assignment_plan
    
    assignment_exercises = []
    
    schedule.each do |rule|
      # max_exercises_this_assignment = current_assignment.max_exercise_count 
      
      topics_exercises = current_assignment_plan.topics.collect{|t| t.topic_exercises}
      
      num_topic_exercises_in_assignment = topics_exercises.collect{|tes| tes.count}.sum
      
      topics_exercises.each do |topic_exercises|
        max_num_exercises_allowed_from_this_topic = 
          min(topic_exercises.size, topic_exercises.size/num_topic_exercises_in_assignment * max_num_assignment_exercises)
          
        num_topic_exercises_to_use = rule[:percent]/100 * max_num_exercises_allowed_from_this_topic
        
        # actually only take from the TEs that have not yet been assigned
        # and build up the Assignment here.  
        
        # for ii = 1..floor(num_topic_exercises_to_use) 
        #   ae = AssignmentExercise.new(:assignment_id => this_assignment.id,
        #                               :topic_exercise_id => topic_exercises[ii])
        # end
      end
      
      
      current_assignment_plan = assignment_plan.predecessor
      break if current_assignment_plan.nil?
    end
    
    # student_exercises = []
    
    
  end
  
end
