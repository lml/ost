# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class LearningCondition < ActiveRecord::Base
  belongs_to :cohort
  
  has_one  :scheduler
  has_many :learning_condition_presentation_conditions, :order => :number
  has_many :learning_condition_feedback_conditions,     :order => :number

  before_create :set_defaults
  
  attr_accessible
  
  def build_assignment(assignment_plan)
    assignment_plan.is_test? ?
    TestBuilder.build_assignment(assignment_plan, cohort) : # take specific percentages from each topics test reserves
    scheduler.build_assignment(assignment_plan, cohort)
  end

  def presentation_conditions
    learning_condition_presentation_conditions.collect{|lcpc| lcpc.presentation_condition}
  end

  def feedback_conditions
    learning_condition_feedback_conditions.collect{|lcfc| lcpc.feedback_condition}
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
  
  def requires_free_response?(student_exercise)
    get_presentation_condition(student_exercise).requires_free_response?
  end

  def requires_follow_up_question?(student_exercise)
    get_presentation_condition(student_exercise).requires_follow_up_question?(student_exercise)
  end

  def follow_up_question(student_exercise)
    get_presentation_condition(student_exercise).follow_up_question
  end

  def requires_selected_answer?(student_exercise)
    get_presentation_condition(student_exercise).requires_selected_answer?
  end

  def is_feedback_available?(student_exercise)
    get_feedback_condition(student_exercise).is_feedback_available?(student_exercise)
  end
  
  def can_automatically_show_feedback?(student_exercise)
    get_feedback_condition(student_exercise).can_automatically_show_feedback?(student_exercise)
  end

  def feedback_required_for_credit?(student_exercise)
    get_feedback_condition(student_exercise).is_feedback_required_for_credit
  end

  def show_correctness_feedback?(thing)
    if thing.is_a?(StudentAssignment)
      show_student_assignment_correctness_feedback?(thing)
    elsif thing.is_a?(StudentExercise)
      show_student_exercise_correctness_feedback?(thing)
    else
      raise "Invalid argument: #{thing}"
    end
  end

  def show_correct_answer_feedback?(student_exercise)
    show_student_exercise_correct_answer_feedback?(student_exercise)
  end

  def show_high_level_feedback?(student_exercise)
    show_student_exercise_high_level_feedback?(student_exercise)
  end

  def show_detailed_feedback?(student_exercise)
    show_student_exercise_detailed_feedback?(student_exercise)
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

  def get_presentation_condition(student_or_assignment_exercise)
    presentation_conditions.detect{|pc| pc.applies_to? student_or_assignment_exercise} || PresentationCondition.default_presentation_condition
  end

  def get_feedback_condition(student_or_assignment_exercise)
    feedback_conditions.detect{|fc| fc.applies_to? student_or_assignment_exercise} || BasicFeedbackCondition.default_feedback_condition
  end

protected

  def show_student_assignment_correctness_feedback?(student_assignment)
    student_assignment.student_exercises.inject(true) { |result, se| result && show_student_exercise_correctness_feedback?(se) }
  end

  def show_student_exercise_correctness_feedback?(student_exercise)
    get_feedback_condition(student_exercise).show_correctness_feedback
  end
  
  def show_student_exercise_correct_answer_feedback?(student_exercise)
    get_feedback_condition(student_exercise).show_correct_answer_feedback
  end

  def show_student_exercise_high_level_feedback?(student_exercise)
    get_feedback_condition(student_exercise).show_high_level_feedback
  end

  def show_student_exercise_detailed_feedback?(student_exercise)
    get_feedback_condition(student_exercise).show_detailed_feedback
  end

  def set_defaults
    self.scheduler = PercentScheduler.standard_practice_scheduler
    self.learning_conditon_presentation_conditions << LearningConditonPresentationCondition.standard_practice_learning_condition_presentation_condition
    self.learning_conditon_feedback_conditions     << LearningConditionFeedbackCondition.standard_practice_learning_condition_feedback_condition
  end

end
