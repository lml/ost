# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class BasicFeedbackCondition < FeedbackCondition
  
  require 'enum'
  
  store_accessor       :settings, :label_regex
  store_typed_accessor :settings, :boolean, :is_feedback_required_for_credit
  store_typed_accessor :settings, :boolean, :can_automatically_show_feedback
  store_typed_accessor :settings, :integer, :availability_opens_option
  store_typed_accessor :settings, :float,   :availability_opens_delay_days
  store_typed_accessor :settings, :integer, :availability_closes_option
  store_typed_accessor :settings, :float,   :availability_closes_delay_days
  store_typed_accessor :settings, :integer, :availability_event
  store_typed_accessor :settings, :integer, :credit_closes_option
  store_typed_accessor :settings, :float,   :credit_closes_delay_days
  store_typed_accessor :settings, :boolean, :show_correctness_feedback
  store_typed_accessor :settings, :boolean, :show_correct_answer_feedback
  store_typed_accessor :settings, :boolean, :show_high_level_feedback
  store_typed_accessor :settings, :boolean, :show_detailed_feedback

  attr_accessible :label_regex, :is_feedback_required_for_credit, 
                  :availability_opens_option, :availability_opens_delay_days, 
                  :availability_closes_option, :availability_closes_delay_days,
                  :availability_event, 
                  :credit_closes_option, :credit_closes_delay_days,
                  :can_automatically_show_feedback,
                  :show_correctness_feedback, :show_correct_answer_feedback,
                  :show_high_level_feedback, :show_detailed_feedback

  after_initialize  :supply_missing_values
  before_validation :strip_and_downcase_regex
  before_validation :nil_out_blank_regex

  validates :availability_opens_delay_days, allow_nil: true,
                                            numericality: { greater_than: 0 }

  validates :availability_closes_delay_days, allow_nil: true,
                                             numericality: { greater_than: 0 }

  validates :credit_closes_delay_days, allow_nil: true,
                                       numericality: { greater_than: 0 }

  validate :delay_days_specified_if_delay_chosen
  validate :credit_window_within_availability_window
  validate :not_applicable_event_only_for_never
  validate :feedback_cannot_close_if_never_opened
  validate :feedback_must_open_if_needed_for_credit
    
  class AvailabilityOpensOption < Enum
    NEVER = 0
    IMMEDIATELY_AFTER_EVENT = 1 
    DELAY_AFTER_EVENT = 2
  end
  
  class AvailabilityClosesOption < Enum
    NEVER = 0
    DELAY_AFTER_OPEN = 1
  end
  
  class AvailabilityEvent < Enum
    NOT_APPLICABLE = 0
    ASSIGNMENT_DUE = 1
    EXERCISE_COMPLETE = 2
    ASSIGNMENT_COMPLETE = 3
  end
  
  class CreditClosesOption < Enum
    WHEN_FEEDBACK_BECOMES_UNAVAILABLE = 0
    DELAY_AFTER_OPEN = 1
  end

  def self.standard_practice_feedback_condition
    BasicFeedbackCondition.new(:label_regex                     => 'standard practice', 
                               :is_feedback_required_for_credit => false.to_s,
                               :availability_opens_option       => AvailabilityOpensOption::IMMEDIATELY_AFTER_EVENT.to_s, 
                               :availability_closes_option      => AvailabilityClosesOption::NEVER.to_s, 
                               :availability_event              => AvailabilityEvent::EXERCISE_COMPLETE.to_s,
                               :credit_closes_option            => CreditClosesOption::WHEN_FEEDBACK_BECOMES_UNAVAILABLE.to_s,
                               :show_correctness_feedback       => true,
                               :show_correct_answer_feedback    => true,
                               :show_high_level_feedback        => true,
                               :show_detailed_feedback          => true)
  end
  
  def self.default_feedback_condition
    BasicFeedbackCondition.new(:label_regex                     => '.*', 
                               :is_feedback_required_for_credit => false.to_s,
                               :availability_opens_option       => AvailabilityOpensOption::IMMEDIATELY_AFTER_EVENT.to_s, 
                               :availability_closes_option      => AvailabilityClosesOption::NEVER.to_s, 
                               :availability_event              => AvailabilityEvent::EXERCISE_COMPLETE.to_s,
                               :credit_closes_option            => CreditClosesOption::WHEN_FEEDBACK_BECOMES_UNAVAILABLE.to_s,
                               :show_correctness_feedback       => false,
                               :show_correct_answer_feedback    => false,
                               :show_high_level_feedback        => false,
                               :show_detailed_feedback          => false)
  end

  def applies_to?(student_or_assignment_exercise)
    label_regex_array = label_regex.split(",").collect{|lr| lr.strip}

    if student_or_assignment_exercise.instance_of? StudentExercise
      assignment_exercise = student_or_assignment_exercise.assignment_exercise
    else
      assignment_exercise = student_or_assignment_exercise
    end

    labels = assignment_exercise.tag_list

    label_regex_array.any? do |regex|
      labels.any? do |label|
        label == regex || label.match(Regexp.new(regex, Regexp::IGNORECASE))
      end
    end
  end
  
  def can_automatically_show_feedback?(student_exercise)
    can_automatically_show_feedback
  end
    
  def is_feedback_available?(student_exercise)
    feedback_opens_at, feedback_closes_at = get_feedback_availability_window(student_exercise)
    
    return (!feedback_opens_at.nil? && !feedback_closes_at.nil?) && 
           (Time.now > feedback_opens_at && Time.now < feedback_closes_at)
  end
  
  def get_feedback_availability_window(student_exercise)
    return [nil, nil] if AvailabilityOpensOption::NEVER == availability_opens_option

    event_occurred_at = 
      case availability_event
      when AvailabilityEvent::ASSIGNMENT_DUE
        student_exercise.has_come_due? && student_exercise.selected_answer_submitted? ? student_exercise.due_at : nil
      when AvailabilityEvent::EXERCISE_COMPLETE
        student_exercise.selected_answer_submitted_at
      when AvailabilityEvent::ASSIGNMENT_COMPLETE
        student_exercise.student_assignment.completed_at
      end

    # If the event hasn't occurred yet, we can't give feedback
    return [nil, nil] if event_occurred_at.nil?
    
    feedback_opens_at =
      case availability_opens_option
      when AvailabilityOpensOption::IMMEDIATELY_AFTER_EVENT
        event_occurred_at
      when AvailabilityOpensOption::DELAY_AFTER_EVENT
        event_occurred_at + availability_opens_delay_days.days
      end

    if feedback_opens_at
      feedback_closes_at =
        case availability_closes_option
        when AvailabilityClosesOption::NEVER
          feedback_opens_at + 100.years
        when AvailabilityClosesOption::DELAY_AFTER_OPEN
          feedback_opens_at + availability_closes_delay_days.days
        end
    end

    return [feedback_opens_at, feedback_closes_at]
  end
  
  def notify_student_exercise_event(student_exercise, event)
    # There are a number of things we may want to do; hand off to specialized
    # methods which can decide to take action if necessary.
    schedule_feedback_availability_notification(student_exercise, event)
    adjust_credit(student_exercise, event)
  end  
  
  def credit_window_close_time(student_exercise)
    if (CreditClosesOption::DELAY_AFTER_OPEN == credit_closes_option) && !credit_closes_delay_days.nil?
      feedback_opens_at, feedback_closes_at = get_feedback_availability_window(student_exercise)
      return nil if feedback_opens_at.nil?
      return feedback_opens_at + credit_closes_delay_days.days
    else
      nil
    end
  end

protected

  def supply_missing_values
    self.label_regex                     ||= '.*'
    self.is_feedback_required_for_credit ||= false
    self.availability_opens_option       ||= AvailabilityOpensOption::NEVER
    self.availability_closes_option      ||= AvailabilityClosesOption::NEVER
    self.availability_event              ||= AvailabilityEvent::NOT_APPLICABLE
    self.credit_closes_option            ||= CreditClosesOption::WHEN_FEEDBACK_BECOMES_UNAVAILABLE
    self.show_correctness_feedback       ||= false 
    self.show_correct_answer_feedback    ||= false
    self.show_high_level_feedback        ||= false
    self.show_detailed_feedback          ||= false
    true
  end
  
  def schedule_feedback_availability_notification(student_exercise, event)
    # Only schedule a feedback availability notification to the student
    # if the feedback opens after a delay and the observed event
    # matches what this condition is configured for, or if the student has
    # to view feedback for credit.

    return unless availability_opens_option == AvailabilityOpensOption::DELAY_AFTER_EVENT ||
                  is_feedback_required_for_credit

    return unless (event == StudentAssignment::Event::DUE &&
                   availability_event == AvailabilityEvent::ASSIGNMENT_DUE) ||
                  (event == StudentAssignment::Event::COMPLETE &&
                   availability_event == AvailabilityEvent::ASSIGNMENT_COMPLETE) ||
                  (event == StudentExercise::Event::COMPLETE &&
                   availability_event == AvailabilityEvent::EXERCISE_COMPLETE)
  
    feedback_opens_at, feedback_closes_at = get_feedback_availability_window(student_exercise)
  
    return if feedback_opens_at.nil? || feedback_closes_at.nil?
                                             
    course = student_exercise.course
    message = BasicFeedbackConditionRenderer.new.feedback_availability_message(self, student_exercise, feedback_closes_at)
    
    ScheduledNotification.create(:user => student_exercise.student.user,
                                 :send_after => feedback_opens_at,
                                 :subject => (course.short_name || course.name || "Exercise") + " feedback available",
                                 :message => message)
  end
  
  def adjust_credit(student_exercise, event)    
    if StudentExercise::Event::COMPLETE == event
      student_exercise.update_feedback_credit_multiplier!(is_feedback_required_for_credit ? 0 : 1)
    end
    
    if StudentExercise::Event::FEEDBACK_VIEWED == event
      if is_feedback_required_for_credit && within_feedback_credit_window?(student_exercise) && student_exercise.feedback_credit_multiplier != 1
        student_exercise.update_feedback_credit_multiplier!(1)
      end
    end
  end
  
  def within_feedback_credit_window?(student_exercise)
    feedback_opens_at, feedback_closes_at = get_feedback_availability_window(student_exercise)
    credit_closes_at = credit_window_close_time(student_exercise)
    current_time = Time.now
    return (current_time >= feedback_opens_at) && (current_time <= credit_closes_at) if (feedback_opens_at && credit_closes_at)
    return true
  end

  def strip_and_downcase_regex
    self.label_regex = label_regex.strip.downcase if !self.label_regex.nil?
  end
  
  def nil_out_blank_regex
    self.label_regex = nil if label_regex.blank?
    true
  end
  
  def delay_days_specified_if_delay_chosen
    errors.add(:availability_opens_delay_days, "must be specified") \
      if AvailabilityOpensOption::DELAY_AFTER_EVENT == availability_opens_option &&
         availability_opens_delay_days.nil?
         
    errors.add(:credit_closes_delay_days, "must be specified") \
      if CreditClosesOption::DELAY_AFTER_OPEN == credit_closes_option &&
         credit_closes_delay_days.nil?

    errors.add(:availability_closes_delay_days, "must be specified") \
      if AvailabilityClosesOption::DELAY_AFTER_OPEN == availability_closes_option &&
         availability_closes_delay_days.nil?
  end
  
  def credit_window_within_availability_window
    if credit_closes_delay_days && availability_closes_delay_days
      errors.add(:credit_closes_delay_days, "must fall within availability window") \
        if AvailabilityClosesOption::DELAY_AFTER_OPEN == availability_closes_option &&
           CreditClosesOption::DELAY_AFTER_OPEN       == credit_closes_option &&
           credit_closes_delay_days > availability_closes_delay_days
    end
  end

  def not_applicable_event_only_for_never
    errors.add(:availability_event, "cannot be NOT APPLICABLE") \
      if AvailabilityEvent::NOT_APPLICABLE == availability_event &&
         AvailabilityOpensOption::NEVER != availability_opens_option
  end
  
  def feedback_cannot_close_if_never_opened
    errors.add(:credit_closes_option, "must be 'when feedback becomes unavailable' since feedback never opens") \
      if AvailabilityOpensOption::NEVER == availability_opens_option &&
         CreditClosesOption::WHEN_FEEDBACK_BECOMES_UNAVAILABLE != credit_closes_option

    errors.add(:availability_closes_option, "must be 'Never' since feedback never opens") \
      if AvailabilityOpensOption::NEVER == availability_opens_option &&
         AvailabilityClosesOption::NEVER != availability_closes_option
  end
    
  def feedback_must_open_if_needed_for_credit
    errors.add(:availabiility_opens_option, "cannot be 'Never' because students must view feedback to get credit") \
      if AvailabilityOpensOption::NEVER == availability_opens_option && is_feedback_required_for_credit
  end
  
end