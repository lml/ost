class BasicFeedbackCondition < FeedbackCondition
  
  require 'enum'
  
  store_accessor       :settings, :label_regex
  store_typed_accessor :settings, :boolean, :is_feedback_required_for_credit
  store_typed_accessor :settings, :integer, :availability_opens_option
  store_typed_accessor :settings, :integer, :availability_opens_delay_days
  store_typed_accessor :settings, :integer, :availability_closes_option
  store_typed_accessor :settings, :integer, :availability_closes_delay_days
  store_typed_accessor :settings, :integer, :availability_event
    
  attr_accessible :label_regex, :is_feedback_required_for_credit, 
                  :availability_opens_option, :availability_opens_delay_days, 
                  :availability_closes_option, :availability_closes_delay_days,
                  :availability_event
                  
  before_validation :init, :on => :create
  before_validation :strip_and_downcase_regex
  before_validation :nil_out_blank_regex

  validates :availability_opens_delay_days, allow_nil: true,
                                            numericality: { only_integer: true,
                                                            greater_than: 0 }

  validates :availability_closes_delay_days, allow_nil: true,
                                             numericality: { only_integer: true,
                                                             greater_than: 0 }

  validate :delay_days_specified_if_delay_chosen
  validate :not_applicable_event_only_for_never
  validate :feedback_cannot_close_if_never_opened
  
  before_save :nil_out_days_if_those_options_not_set
  
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
  
  def applies_to?(student_exercise)
    label_regex_array = label_regex.split(",").collect{|lr| lr.strip}
    labels = student_exercise.assignment_exercise.tag_list
    
    label_regex_array.any? do |regex|
      labels.any? do |label|
        label == regex || label.match(regex)
      end
    end
  end
  
  def is_feedback_available?(student_exercise)
    return false if AvailabilityOpensOption::NEVER == availability_opens_option

    event_occurred_at = 
      case availability_event
      when AvailabilityEvent::ASSIGNMENT_DUE
        student_exercise.due_at
      when AvailabilityEvent::EXERCISE_COMPLETE
        student_exercise.selected_answer_submitted_at
      when AvailabilityEvent::ASSIGNMENT_COMPLETE
        student_exercise.student_assignment.completed_at
      end

    # If the event hasn't occurred yet, we can't give feedback
    return false if event_occurred_at.nil?
    
    feedback_opens_at =
      case availability_opens_option
      when AvailabilityOpensOption::IMMEDIATELY_AFTER_EVENT
        event_occurred_at
      when AvailabilityOpensOption::DELAY_AFTER_EVENT
        event_occurred_at + availability_opens_delay_days.days
      end

    feedback_closes_at =
      case availability_closes_option
      when AvailabilityClosesOption::NEVER
        event_occurred_at + 100.years
      when AvailabilityClosesOption::DELAY_AFTER_OPEN
        event_occurred_at + availability_closes_delay_days.days
      end

    return Time.now > feedback_opens_at && Time.now < feedback_closes_at
  end
  
protected

  def init
    self.is_feedback_required_for_credit ||= false
    self.availability_opens_option ||= AvailabilityOpensOption::NEVER
    self.availability_closes_option ||= AvailabilityClosesOption::NEVER
    self.availability_event ||= AvailabilityEvent::NOT_APPLICABLE
    true
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
         
    errors.add(:availability_closes_delay_days, "must be specified") \
      if AvailabilityClosesOption::DELAY_AFTER_OPEN == availability_closes_option &&
         availability_closes_delay_days.nil?
  end
  
  def not_applicable_event_only_for_never
    errors.add(:availability_event, "cannot be NOT APPLICABLE") \
      if AvailabilityEvent::NOT_APPLICABLE == availability_event &&
         AvailabilityOpensOption::NEVER != availability_opens_option
  end
  
  def feedback_cannot_close_if_never_opened
    errors.add(:availability_closes_option, "must be 'Never' since feedback never opens") \
      if AvailabilityOpensOption::NEVER == availability_opens_option &&
         AvailabilityClosesOption::NEVER != availability_closes_option
  end
  
  def nil_out_days_if_those_options_not_set
    self.availability_opens_delay_days = nil if AvailabilityOpensOption::DELAY_AFTER_EVENT != availability_opens_option
    self.availability_closes_delay_days = nil if AvailabilityClosesOption::DELAY_AFTER_OPEN != availability_closes_option
    true
  end
  
end