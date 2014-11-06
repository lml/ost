# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class StudentExercise < ActiveRecord::Base
  
  require 'enum'
  
  belongs_to :student_assignment
  belongs_to :assignment_exercise
  has_many :response_times, :as => :response_timeable, :dependent => :destroy
  has_many :free_responses, :dependent => :destroy, :order => :number
  has_one :student, :through => :student_assignment
  has_one :consent, :through => :student
  has_one :topic_exercise, :through => :assignment_exercise
  has_one :topic, :through => :topic_exercise

  before_destroy :destroyable?, prepend: true
  
  validates :student_assignment_id, :presence => true
  validates :assignment_exercise_id, :presence => true, 
                                     :uniqueness => {:scope => :student_assignment_id}

  validates :free_response_confidence, 
              :presence => {:if => Proc.new{|se| !se.skip_confidence && se.lock_response_text_on_next_save}},
              :numericality => {:greater_than_or_equal_to => 0, 
                                :less_than_or_equal_to => 4, 
                                :allow_nil => true}

  validates :follow_up_answer,
            :presence => {:if => 
              Proc.new{|se| 
                (se.requires_free_response? && se.free_responses.any? || se.present_selected_answer_only? && se.selected_answer_changed?) && 
                se.requires_follow_up_question?
              }
            }

  # If the free response has been submitted, the next update should have a selected answer
  validates :selected_answer, :presence => {:if => Proc.new{|se| se.free_response_submitted?}}
  
  # Past due answers now allowed, but get no credit # TODO make configurable by course
  # validate :not_past_due, :on => :update 
  
  validate :changes_match_state, :on => :update
  validate :has_at_least_one_free_response, :on => :update

  # Gets the list of student exercises visible for the given user
  scope :visible, lambda { |user|
    if user.is_researcher? || user.is_visitor?
      joins{student_assignment.student.consent}
        .where{{student_assignment.student.consent => sift(:did_consent)}}
    else
      scoped
    end
  }

  # Gets the list of student exercises sorted by student status
  # (dropped / auditing) and the last name.
  scope :by_student, joins{student_assignment.student.user}
                       .includes{student_assignment.student.user}
                       .order{[student_assignment.student.has_dropped,
                               student_assignment.student.is_auditing,
                               lower(student_assignment.student.users.last_name)]}

  after_save :update_cached_conditions

  before_save :lock_choice_if_indicated, :on => :update

  attr_accessor :lock_response_text_on_next_save
  before_save :lock_response_text_if_directed, :on => :update

  attr_accessor :skip_update_callbacks
  before_save :notify_updated, :on => :update
  
  after_save :notify_if_answer_selected, :on => :update
  
  attr_accessible :free_response_confidence, :selected_answer, :feedback_credit_multiplier, :follow_up_answer

  attr_accessor :skip_confidence

  # Realized a little late in the game that it is bad when these numbers are the same as
  # the Event enum numbers in student assignment, so made them different
  class Event < Enum
    DUE = 200
    COMPLETE = 201 
    FEEDBACK_VIEWED = 202
  end

  # Retrieves cached feedback condition or loads from scratch.
  def feedback_condition
    feedback_condition_id.present? ? 
      @feedback_condition ||= FeedbackCondition.find(feedback_condition_id) :
      set_feedback_condition_from_scratch
  end

  # Retrieves cached presentation condition or loads from scratch.
  def presentation_condition
    presentation_condition_id.present? ?
      @presentation_condition ||= PresentationCondition.find(presentation_condition_id) :
      set_presentation_condition_from_scratch
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

  def is_test?
    assignment.assignment_plan.is_test?
  end

  def student
    student_assignment.student
  end
  
  def status
    return "NOT YET ANSWERED" if requires_free_response? && !free_response_submitted?
    return "COMPLETED"        if complete?
    return "NOT COMPLETE"
  end

  def complete?
    selected_answer_submitted?
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
    presentation_condition.requires_free_response?
  end

  def requires_selected_answer?
    presentation_condition.requires_selected_answer?
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
    @learning_condition ||= LearningCondition.joins{cohort.students.student_assignments}
                            .where{cohort.students.student_assignments.id == my{student_assignment_id}}
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
    feedback_condition.is_feedback_available?(self)
  end
  
  def can_automatically_show_feedback?
    feedback_condition.can_automatically_show_feedback?(self)
  end

  def show_correctness_feedback?
    feedback_condition.show_correctness_feedback
  end

  def feedback_has_been_viewed?
    complete? && (feedback_first_viewed_at || response_times.where{page == "feedback"}.any?)
  end

  def feedback_has_been_viewed_for_credit?
    feedback_has_been_viewed? && (feedback_credit_multiplier == 1)
  end

  def feedback_required_for_credit?
    feedback_condition.is_feedback_required_for_credit
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

  def requires_follow_up_question?
    presentation_condition.requires_follow_up_question?(self)
  end

  def follow_up_question
    learning_condition.follow_up_question(self)
  end

  def self.update_page_view_info!
    StudentExercise.update_exercise_first_viewed_at_times!
    StudentExercise.update_feedback_first_viewed_at_times!
    StudentExercise.update_feedback_view_counts!
  end

  def self.update_exercise_first_viewed_at_times!(max_num_updates = 5000)
    student_exercises = StudentExercise.where{exercise_first_viewed_at == nil}
                                       .joins{response_times}
                                       .where{response_times.page == 'work'}
                                       .where{response_times.note =~ 'READY%'}
                                       .select{distinct(id)}
                                       .limit(max_num_updates)
                                       .readonly(false)

    student_exercises.each do |student_exercise|
      response_time = student_exercise.response_times
                                      .where{page == "work"}
                                      .where{note =~ "READY%"}
                                      .order('CREATED_AT ASC')
                                      .limit(1).first

      student_exercise.exercise_first_viewed_at = response_time.created_at

      student_exercise.skip_update_callbacks = true
      student_exercise.save! validate: false
      student_exercise.skip_update_callbacks = false
    end

    student_exercises.count
  end

  def self.update_feedback_first_viewed_at_times!(max_num_updates = 5000)
    student_exercises = StudentExercise.where{feedback_first_viewed_at == nil}
                                       .joins{response_times}
                                       .where{response_times.page == 'feedback'}
                                       .where{response_times.note =~ 'READY%'}
                                       .select{distinct(id)}
                                       .limit(max_num_updates)
                                       .readonly(false)

    student_exercises.each do |student_exercise|
      response_time = student_exercise.response_times
                                      .where{page == "feedback"}
                                      .where{note =~ "READY%"}
                                      .order('CREATED_AT ASC')
                                      .limit(1).first

      student_exercise.feedback_first_viewed_at = response_time.created_at

      student_exercise.skip_update_callbacks = true
      student_exercise.save! validate: false
      student_exercise.skip_update_callbacks = false
    end

    student_exercises.count
  end

  def self.update_feedback_view_counts!(max_num_updates = 5000)
    query_time = Time.now

    student_exercises = StudentExercise.joins{response_times}
                                       .where{response_times.page       == 'feedback'}
                                       .where{response_times.note       =~ 'READY%'}
                                       .where{response_times.created_at >= ~feedback_views_timestamp}
                                       .where{response_times.created_at <  query_time}
                                       .select{distinct(id)}
                                       .limit(max_num_updates)
                                       .readonly(false)

    student_exercises.each do |student_exercise|
      student_exercise.feedback_views_timestamp = query_time
      student_exercise.feedback_views_count     = student_exercise.response_times
                                                                  .where{page == "feedback"}
                                                                  .where{note =~ "READY%"}
                                                                  .count

      student_exercise.skip_update_callbacks = true
      student_exercise.save! validate: false
      student_exercise.skip_update_callbacks = false
    end

    student_exercises.size
  end

  def spaced_practice?
    source_topic_id = assignment_exercise.topic_exercise.topic_id
    assignment_exercise.assignment.assignment_plan.assignment_plan_topics.all.none?{|apt| apt.topic_id == source_topic_id}
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
    # TODO see if the following statement works (also do in is_teacher? below)
    # joins{student_assignment.student.user}.any{student_assignment.student.user_id == my{user}.id}
  end

  def belongs_to_active_student_user?(user)
    belongs_to_student_user?(user) && student_assignment.student.active?
  end
  
  def klass
    student_assignment.student.section.klass
  end

  def is_teacher?(user)
    klass.is_teacher?(user)
  end

  def is_educator?(user)
    klass.is_educator?(user)
  end

  def destroyable?
    return true if sudo_enabled?
    errors.add(:base, "This student exercise cannot be destroyed (except by admin override)")
    errors.none?
  end
  
  def note_feedback_viewed!
    if Rails.env.development?
      if feedback_first_viewed_at.blank?
        self.skip_update_callbacks = true
        self.update_attribute(:feedback_first_viewed_at, Time.now)
        self.skip_update_callbacks = false
      end
    end
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

  def update_cached_conditions
    return true if self.skip_update_callbacks

    # Whenever we save an SE, it is possible that its feedback or presentation conditions
    # could change (since they are based on the state of the SE).  To be sure that an 
    # invalid cached condition doesn't stick around, we update them here.

    set_feedback_condition_from_scratch
    set_presentation_condition_from_scratch

    self.update_column(:feedback_condition_id, @feedback_condition.id)
    self.update_column(:presentation_condition_id, @presentation_condition.id)
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

  def set_feedback_condition_from_scratch
    @feedback_condition = learning_condition.get_learning_condition_feedback_condition(self).feedback_condition 
  end

  def set_presentation_condition_from_scratch
    @presentation_condition = learning_condition.get_learning_condition_presentation_condition(self).presentation_condition
  end
                  
end
