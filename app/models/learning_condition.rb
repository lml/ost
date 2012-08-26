class LearningCondition < ActiveRecord::Base
  belongs_to :cohort
  
  has_one :scheduler
  has_many :feedback_conditions, :order => :number
  
  before_create :set_defaults
  
  attr_accessible
  
  def build_assignment(assignment_plan)
    assignment_plan.is_test? ?
    TestBuilder.build_assignment(assignment_plan, cohort) : # take specific percentages from each topics test reserves
    scheduler.build_assignment(assignment_plan, cohort)
  end
  
  # Student exercises and assignments are supposed to notify their learning
  # condition when certain events happen, e.g.:
  #
  #    first viewed the feedback
  #    finished the problem
  #    finished the assignment
  #    assignment became due
  #
  # The learning condition then lets its children take action as needed
  
  def notify_student_exercise_event(student_exercise, event)
    # Currently, we just pass to the feedback condition, not the scheduler
    get_feedback_condition(student_exercise).notify_student_exercise_event(student_exercise, event)
  end

  def notify_student_assignment_event(student_assignment, event)
    # Feedback conditions work on the exercise level, not the assignment level,
    # but there are assignment-level events we care about, so just pass all of
    # an assignments events along to the other method along with the event.
    student_assignment.student_exercises.each do |student_exercise|
      notify_student_exercise_event(student_exercise, event)
    end
  end
  
  def is_feedback_available?(student_exercise)
    get_feedback_condition(student_exercise).is_feedback_available?(student_exercise)
  end
  
  def can_automatically_show_feedback?(student_exercise)
    get_feedback_condition(student_exercise).can_automatically_show_feedback?(student_exercise)
  end
  
  #############################################################################
  # Access control methods
  #############################################################################

  def can_be_read_by?(user)
    can_anything?(user)
  end

  def can_be_created_by?(user)
    can_anything?(user)
  end

  def can_be_updated_by?(user)
    can_anything?(user)
  end

  def can_be_destroyed_by?(user)
    can_anything?(user)
  end
  
  def can_anything?(user)
    # If the class is not the subject of formal research, a learning
    # condition is still necessary and needs to be available to the
    # instructors
    
    cohort.klass.is_controlled_experiment ? 
      Researcher.is_one?(user) || user.is_administrator? :
      cohort.klass.is_instructor?(user) || user.is_administrator?
  end
  
protected

  def get_feedback_condition(student_exercise)
    feedback_conditions.detect{|fc| fc.applies_to?(student_exercise)} ||
    DummyFeedbackCondition.new
  end
  
  def set_defaults
    self.scheduler = PercentScheduler.standard_practice_scheduler
    self.feedback_conditions << BasicFeedbackCondition.immediate_feedback_condition
  end

end
