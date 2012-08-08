class PercentScheduler < ActiveRecord::Base
  store :settings, accessors: [:schedules]
  
  attr_accessible :learning_condition_id, :settings
  
  def build_student_assignments(this_assignment, cohort)
    learning_plan = this_assignment.learning_plan
    all_assignments = learning_plan.assignments
    this_assignment_number = all_assignments.index{|a| a.id == this_assignment.id}
    
    schedule_number = this_assignment_number % schedules.size
    schedule = schedules[schedule_number]
    
    max_num_assignment_exercises = this_assignment.max_num_exercises
    
    current_assignment = this_assignment
    
    assignment_exercises = []
    
    schedule.each do |rule|
      # max_exercises_this_assignment = current_assignment.max_exercise_count 
      
      topics_exercises = current_assignment.topics.collect{|t| t.topic_exercises}
      
      num_topic_exercises_in_assignment = topics_exercises.collect{|tes| tes.count}.sum
      
      topics_exercises.each do |topic_exercises|
        max_num_exercises_allowed_from_this_topic = 
          min(topic_exercises.size, topic_exercises.size/num_topic_exercises_in_assignment * max_num_assignment_exercises)
          
        num_topic_exercises_to_use = rule[:percent]/100 * max_num_exercises_allowed_from_this_topic
        
        # actually only take from the TEs that have not yet been assigned
        for ii = 1..floor(num_topic_exercises_to_use) 
          ae = AssignmentExercise.new(:assignment_id => this_assignment.id,
                                      :topic_exercise_id => topic_exercises[ii])
        end
      end
      
      
      current_assignment = assignment.predecessor
      break if current_assigment.nil?
    end
    
    student_exercises = []
    
    
  end
  
end
