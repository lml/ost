class BasicFeedbackCondition < FeedbackCondition
  
  require 'enum'
  
  store_accessor       :settings, :label_regex
  store_typed_accessor :settings, :boolean, :is_feedback_required_for_credit
  store_typed_accessor :settings, :integer, :availability_opens_option
  store_typed_accessor :settings, :integer, :availability_opens_delay_days
  store_typed_accessor :settings, :integer, :availability_closes_option
  store_typed_accessor :settings, :integer, :availability_closes_delay_days
  store_typed_accessor :settings, :integer, :availability_event

  # store_typed_accessor :settings, :integer, :test
    
  attr_accessible :label_regex, :is_feedback_required_for_credit, 
                  :availability_opens_option, :availability_opens_delay_days, 
                  :availability_closes_option, :availability_closes_delay_days,
                  :availability_event
                  
  before_validation :init, :on => :create
  before_validation :strip_and_downcase_regex
  before_validation :nil_out_blank_regex

  validates :availability_opens_delay_days, numericality: { only_integer: true,
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
    student_exercise.selected_answer_submitted? # && need information about the state of the SE and assignment
  end
  
protected

  def init
    self.is_feedback_required_for_credit ||= false
    self.availability_opens_option ||= AvailabilityOpensOption::NEVER
    self.availability_closes_option ||= AvailabilityClosesOption::NEVER
    true
  end
  
  def strip_and_downcase_regex
    self.label_regex.strip!.downcase!
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