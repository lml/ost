# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class StudentExercise < ActiveRecord::Base
  
  require 'enum'
  
  belongs_to :student_assignment
  belongs_to :assignment_exercise
  has_many :response_times, :as => :response_timeable, :dependent => :destroy
  has_many :free_responses, :dependent => :destroy, :order => :number
  
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
  validate :has_at_least_one_free_response, :on => :update
  
  before_save :lock_choice_if_indicated, :on => :update

  attr_accessor :lock_response_text_on_next_save
  before_save :lock_response_text_if_directed, :on => :update

  attr_accessor :skip_update_callbacks
  before_save :notify_updated, :on => :update
  
  after_save :notify_if_answer_selected, :on => :update
  
  attr_accessible :free_response_confidence, :selected_answer, :feedback_credit_multiplier

  # Realized a little late in the game that it is bad when these numbers are the same as
  # the Event enum numbers in student assignment, so made them different
  class Event < Enum
    DUE = 200
    COMPLETE = 201 
    FEEDBACK_VIEWED = 202
  end

  def due_at
    assignment.assignment_plan.ends_at
  end
  
  def has_come_due?
    due_at < Time.now
  end

  def exercise
    assignment_exercise.topic_exercise.exercise
  end

  def correct_choice_index
    exercise.correct_choice_index
  end

  def solutions_content
    exercise.solutions_content
  end

  def assignment
    assignment_exercise.assignment
  end  

  def student
    student_assignment.student
  end
  
  def status
    return "NOT YET ANSWERED" if requires_free_response? && !free_response_submitted?
    return "COMPLETED"        if selected_answer_submitted?
    return "NOT COMPLETE"
  end
  
  def present_free_response_and_selected_answer?
    requires_free_response? && requires_selected_answer?
  end

  def present_free_response_only?
    !present_free_response_and_selected_answer? && requires_free_response?
  end

  def present_selected_answer_only?
    !present_free_response_and_selected_answer? && requires_selected_answer?
  end

  def requires_free_response?
    learning_condition.requires_free_response?(self)
  end

  def requires_selected_answer?
    learning_condition.requires_selected_answer?(self)
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
    self.update_attribute(:automated_credit, 1)
  end

  def score
    (was_submitted_late || automated_credit.nil?) ? 0 : (feedback_credit_multiplier * automated_credit)
  end
  
  def learning_condition
    # a joins approach instead of doing multiple queries to get up the containment chain
    LearningCondition.joins{cohort.students.student_assignments.student_exercises}
                     .where{cohort.students.student_assignments.student_exercises.id == my{id}}
                     .first
  end
  
  def course
    Course.joins{klasses.sections.students.student_assignments.student_exercises}
          .where{klasses.sections.students.student_assignments.student_exercises.id == my{id}}
          .first
  end
  
  def klass
    Klass.joins{sections.students.student_assignments.student_exercises}
         .where{sections.students.student_assignments.student_exercises.id == my{id}}
         .first
  end

  def is_feedback_available?
    learning_condition.is_feedback_available?(self)
  end
  
  def can_automatically_show_feedback?
    learning_condition.can_automatically_show_feedback?(self)
  end

  def show_correctness_feedback?
    learning_condition.show_correctness_feedback?(self)
  end

  def get_mail_hook
    MailHook.get_for(self)
  end

  def create_mail_hook
    MailHook.create_with_random_subject(self)
  end

  def process_hooked_mail(mail)
    FreeResponseFactory.create_from_mail(mail, self)
  end

  #############################################################################
  # Access control methods
  #############################################################################

  def can_be_read_by?(user)
    return false          if user.is_anonymous?
    return !klass.closed? if belongs_to_active_student_user?(user)
    return true           if is_educator?(user)
    return true           if user.is_administrator?
    return false
  end

  def can_be_updated_by?(user)
    return false          if user.is_anonymous?
    return !klass.closed? if belongs_to_active_student_user?(user)
    return false
  end

  def can_be_changed_by?(user)
    return false if user.is_anonymous?
    return true  if is_educator?(user)
    return true  if user.is_administrator?
    return false
  end
  
  def belongs_to_student_user?(user)
    student_assignment.student.user_id == user.id
    # TODO see if the following statement works (also do in is_educator? below)
    # joins{student_assignment.student.user}.any{student_assignment.student.user_id == my{user}.id}
  end

  def belongs_to_active_student_user?(user)
    belongs_to_student_user?(user) && student_assignment.student.active?
  end
  
  def is_educator?(user)
    student_assignment.student.section.klass.is_educator?(user)
  end

  def destroyable?
    return true if sudo_enabled?
    errors.add(:base, "This student exercise cannot be destroyed (except by admin override)")
    errors.none?
  end
  
  def note_feedback_viewed!
    notify_observers(:feedback_viewed)
  end
  
  def update_feedback_credit_multiplier!(value)
    self.skip_update_callbacks = true
    self.update_attribute(:feedback_credit_multiplier, value)
    self.skip_update_callbacks = false
  end

  def free_responses_can_be_updated?
    return !free_response_submitted?
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
    if selected_answer_changed? && !skip_update_callbacks
      self.selected_answer_submitted_at = Time.now 
      self.automated_credit = assignment_exercise.topic_exercise.exercise.get_credit(selected_answer)
      self.was_submitted_late = assignment_exercise.assignment.assignment_plan.ends_at < Time.now 
      notify_observers(:selected_answer_to_be_locked)
    end
  end

  def notify_updated
    notify_observers(:updated) unless skip_update_callbacks
  end
  
  def notify_if_answer_selected
    notify_observers(:answer_selected) if selected_answer_changed? && !skip_update_callbacks
  end

  def has_at_least_one_free_response
    errors.add(:base, "At least one answer is required before you can turn this exercise in.") \
      if lock_response_text_on_next_save && free_responses.none?
  end
                  
end
