class PercentScheduler < ActiveRecord::Base
  belongs_to :learning_condition
  
  store :settings, accessors: [:schedules]
  
  # todo validates :schedules
  
  attr_accessible :learning_condition, :settings
  
  # TODO instead of taking a cohort this could take a cohort or a study
  # result would still be an assignmnent, but if the assignment is for a study
  # it could have separate properties, different consent, etc
  def build_assignment(assignment_plan, cohort)
    
    schedule_number = assignment_plan.number % schedules.size
    schedule = schedules[schedule_number]
    
    max_num_assignment_exercises = assignment_plan.max_num_exercises
    current_assignment_plan = assignment_plan
    
    # TODO see if we can just do this with new, not create (ditto for 
    # AssignedExercise below - that way we can build an assignment just to
    # preview it)
    assignment = Assignment.new(:assignment_plan => assignment_plan,
                                :cohort => cohort)
    
    schedule.each do |rule|    
      topics = current_assignment_plan.topics      
      num_plan_exercises = topics.collect{|t| t.topic_exercises.size}.sum

      if num_plan_exercises > 0

        topics.each do |topic|
          topic_exercises = topic.topic_exercises
          num_topic_exercises = topic_exercises.size
        
          max_num_exercises_from_this_topic = 
            min(num_topic_exercises, 
                num_topic_exercises/num_plan_exercises * max_num_assignment_exercises)
        
          # Don't round yet (?)
          num_topic_exercises_to_use = floor(rule[:percent]/100 * max_num_exercises_from_this_topic)
        
          # Ignore topic exercises that have previously been assigned
          topic_exercises.reject!{|te| te.assigned?}        
          topic_exercises = topic_exercises.take( num_topic_exercises_to_use )

          topic_exercises.each do |topic_exercise|
            assignment.assigned_exercises <<
              AssignedExercise.new(:assignment => assignment,
                                   :topic_exercise => topic_exercise)

            # AssignedExercise.create(:assignment => assignment,
            #                         :topic_exercise => topic_exercise)
            # TODO add tags here!
          end        
        end 
      
      end
      
      current_assignment_plan = assignment_plan.predecessor
      break if current_assignment_plan.nil?
    end
    
    assignment    
  end
  
end
