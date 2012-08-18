class StudentExercise < ActiveRecord::Base
  belongs_to :student_assignment
  belongs_to :assignment_exercise
  has_many :response_times, :as => :response_timeable, :dependent => :destroy
  
  before_destroy :destroyable?
  
  validates :student_assignment_id, :presence => true
  validates :assignment_exercise_id, :presence => true, 
                                     :uniqueness => {:scope => :student_assignment_id}

  validates :free_response_confidence, 
              :presence => {:if => Proc.new{|se| se.lock_response_text_on_next_save}},
              :numericality => {:greater_than_or_equal_to => 0, 
                                :less_than_or_equal_to => 4, 
                                :allow_nil => true}

  # If the free response has been submitted, the next update should have a selected answer
  validates :selected_answer, :presence => {:if => Proc.new{|se| se.free_response_submitted?}}
  
  # Past due answers now allowed, but get no credit # TODO make configurable by course
  # validate :not_past_due, :on => :update 
  
  validate :changes_match_state, :on => :update

  before_save :lock_choice_if_indicated, :on => :update

  attr_accessor :lock_response_text_on_next_save
  before_save :lock_response_text_if_directed, :on => :update

  attr_accessor :skip_update_callbacks
  before_save :notify_updated, :on => :update
  
  attr_accessible :free_response, :free_response_confidence, :selected_answer

  def due_at
    assignment.assignment_plan.ends_at
  end

  def assignment
    assignment_exercise.assignment
  end  
  
  def student
    student_assignment.student
  end
  
  def status
    return "NOT YET ANSWERED" if !free_response_submitted?
    return "COMPLETED" if selected_answer_submitted?
    return "NOT COMPLETE"
  end
        
  def free_response_submitted?
    !free_response_submitted_at.nil?
  end
      
  def selected_answer_submitted?
    !selected_answer_submitted_at.nil?
  end   
  
  def is_correct?
    1.0 == automated_credit
  end
  
  def force_to_be_correct!
    self.skip_update_callbacks = true
    self.update_attribute(:selected_answer, assignment_exercise.topic_exercise.exercise.correct_choice_index)
    self.skip_update_callbacks = true
    self.update_attribute(:credit, 1)
  end

  def score
    was_submitted_late ? 0 : credit
  end
  
  def learning_condition
    # a joins approach instead of doing multiple queries to get up the containment chain
    LearningCondition.joins{cohort.students.student_assignments.student_exercises}
                     .where{cohort.students.student_assignments.student_exercises.id == id}
                     .first
  end
  
  def is_feedback_available?
    learning_condition.is_feedback_available?(self)
  end

  #############################################################################
  # Access control methods
  #############################################################################

  def can_be_read_by?(user)
    !user.is_anonymous? && (belongs_to_student_user?(user) || is_educator?(user))
  end

  def can_be_updated_by?(user)
    !user.is_anonymous? && belongs_to_student_user?(user)
  end

  def can_be_changed_by?(user)
    !user.is_anonymous? && is_educator?(user)
  end
  
  def belongs_to_student_user?(user)
    student_assignment.student.user_id == user.id
    # TODO see if the following statement works (also do in is_educator? below)
    # joins{student_assignment.student.user}.any{student_assignment.student.user_id == my{user}.id}
  end
  
  def is_educator?(user)
    student_assignment.student.section.klass.is_educator?(user)
  end
  
  def destroyable?
    raise NotYetImplemented
  end

protected

  def lock_response_text_if_directed
    if lock_response_text_on_next_save && !skip_update_callbacks
      self.free_response_submitted_at = Time.now 
      notify_observers(:free_response_to_be_locked)
    end
  end

  def not_past_due
    return true if assignment_exercise.assignment.assignment_plan.end_date > Time.now
    errors.add(:base, "This response cannot be changed because its assignment's" + 
                      " due date has passed.") && false
  end

  def changes_match_state
    return true if !free_response_submitted?
    return true if !selected_answer_submitted? && (["selected_answer"] == self.changed || [] == self.changed)
    errors.add(:base, "The response to this exercise cannot be modified.") && false
  end

  def lock_choice_if_indicated 
    # Lock the response choice in if it has been made, and take this chance to 
    # populate the credit the student gets for this answer.
    if ["selected_answer"] == self.changed && !skip_update_callbacks
      self.selected_answer_submitted_at = Time.now 
      self.automated_credit = assignment_exercise.topic_exercise.exercise.get_credit(selected_answer)
      self.was_submitted_late = assignment_exercise.assignment.assignment_plan.ends_at < Time.now 
      notify_observers(:selected_answer_to_be_locked)
    end
  end

  def notify_updated
    notify_observers(:updated) unless skip_update_callbacks
  end
                  
end
