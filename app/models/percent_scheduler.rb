class PercentScheduler < Scheduler
  store_accessor :settings, :schedules
  
  validate :schedules_ok
  
  before_create :init_schedules
  
  attr_accessible :schedules
  
  def self.standard_practice_scheduler
    new_scheduler = PercentScheduler.new
    new_scheduler.schedules = [[{:percent => 100, :tags => "standard practice"}]]
    new_scheduler
  end
  
  # Adds a schedule and returns it
  def add_schedule
    self.schedules.push([{:percent => 0, :tags => ""}]).last
  end
  
  # Adds a row to a specific schedule and returns the row along with 
  # the row number (1-indexed)
  def add_schedule_row(number)
    [self.schedules[number].push({:percent => 0, :tags => ""}).last, 
     self.schedules[number].size]
  end
  
  def pop_schedule_row(schedule_number)
    self.schedules[schedule_number].pop
  end
  
  # TODO instead of taking a cohort this could take a cohort or a study
  # result would still be an assignmnent, but if the assignment is for a study
  # it could have separate properties, different consent, etc
  def build_assignment(assignment_plan, cohort)
    
    # This method is not appropriate for test assignment plans
    raise IllegalOperation if assignment_plan.is_test
    
    schedule_number = assignment_plan.number % schedules.size
    schedule = schedules[schedule_number]
    
    max_num_assignment_exercises = assignment_plan.max_num_exercises
    current_assignment_plan = assignment_plan
    
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
            max_num_assignment_exercises.nil? ?
            num_topic_exercises :
            min(num_topic_exercises, 
                num_topic_exercises/num_plan_exercises * max_num_assignment_exercises)
        
          num_topic_exercises_to_use = (rule[:percent].to_i/100.0 * max_num_exercises_from_this_topic).floor
        
          # Ignore topic exercises that have previously been assigned for this cohort
          # or that are reserved for tests
          topic_exercises.reject!{|te| te.reserved_for_tests || te.assigned_in_cohort?(cohort)}        
          topic_exercises = topic_exercises.take( num_topic_exercises_to_use )

          topic_exercises.each_with_index do |topic_exercise, tt|
            assignment.add_topic_exercise(topic_exercise, rule[:tags])
          end        
        end 
      
      end

      current_assignment_plan = current_assignment_plan.predecessors.non_tests.first
      break if current_assignment_plan.nil?
    end
    
    assignment    
  end
  
protected

  def init_schedules
    self.schedules ||= []
  end
  
  def schedules_ok
    (schedules || []).each_with_index do |schedule, index|
      ps = PercentSchedule.new(schedule)
      if !ps.valid?
        ps.errors[:base].each do |msg|
          self.errors.add(:base, msg)
        end
      end
    end
    errors.none?
  end
  
end
