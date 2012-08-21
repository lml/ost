class AssignmentPlan < ActiveRecord::Base
  belongs_to :learning_plan
  has_many :assignments, :dependent => :destroy
  has_many :assignment_plan_topics, :dependent => :destroy
  has_many :topics, :through => :assignment_plan_topics
  has_many :observations, :as => :observable
  
  before_destroy :destroyable?

  ##
  ## Start and end times
  ##

  attr_accessible :starts_at, :ends_at
  attr_accessor :starts_at_string, :ends_at_string # virtual
  attr_accessible :starts_at_string, :ends_at_string
  
  before_validation :initialize_starts_ends_at # will abort validations if returns false
  validates :starts_at, :ends_at, :presence => true
  validates :ends_at, :date => {:after => :starts_at, :message => "End time must be after start time"}, :if => :starts_ends_at_present?
  validate :starts_ends_at_in_bounds
  
  def starts_ends_at_present?
    starts_at.present? && ends_at.present?
  end

  def initialize_starts_ends_at
    if starts_at_string.present? || ends_at_string.present? 
      # construct from starts_at/ends_at strings
      initialize_starts_at_from_string
      initialize_ends_at_from_string
    else
      # constructing default using other AssignmentPlans in Klass
      initialize_starts_ends_at_default
    end
    errors.none?
  end

  def initialize_starts_ends_at_default
    return if !starts_at.nil? && !ends_at.nil?
    
    latest_end = peers.blank? ? nil : peers.collect{|p| p.ends_at}.max

    self.starts_at = latest_end.nil? ? learning_plan.klass.start_date : latest_end
    self.ends_at = self.starts_at + 7.days

    if self.ends_at > learning_plan.klass.end_date
      self.ends_at = learning_plan.klass.end_date
      self.starts_at = self.ends_at - 7.days
      
      if self.starts_at < learning_plan.klass.start_date
        self.starts_at = learning_plan.klass.start_date
      end
    end
  end

  def initialize_starts_at_from_string
    self.starts_at = nil
    if starts_at_string.present?
      self.starts_at = TimeUtils.time_and_zone_strings_to_utc_time(starts_at_string, learning_plan.klass.time_zone)
    else
      errors.add(:starts_at, 'can\'t be blank')
    end
  rescue Exception => ex
    errors.add(:starts_at_string, 'could not be parsed')
  end

  def initialize_ends_at_from_string
    self.ends_at = nil
    if ends_at_string.present?
      self.ends_at = TimeUtils.time_and_zone_strings_to_utc_time(ends_at_string, learning_plan.klass.time_zone)
    else
      errors.add(:ends_at, 'can\'t be blank')
    end
  rescue Exception => ex
    errors.add(:ends_at_string, 'could not be parsed')
  end

  def starts_ends_at_in_bounds
    errors.add(:starts_at, "This assignment cannot start before its class starts.") if starts_at < learning_plan.klass.start_date
    errors.add(:ends_at, "This assignment cannot end after its class ends.") if ends_at > learning_plan.klass.end_date
  end


  
  validates :name, :presence => true, :uniqueness => {:scope => :learning_plan_id}
  validates :max_num_exercises, :allow_nil => true, :numericality => { :greater_than_or_equal_to => 0 }
  
  attr_accessible :introduction, :is_group_work_allowed, :is_open_book, 
                  :is_ready, :is_test, :learning_plan_id, :name, :learning_plan
  
  scope :non_tests, where(:is_test => false)
  scope :tests, where(:is_test => true)
  scope :started, where{starts_at.lt Time.now}
  scope :not_finished, where{ends_at.gt Time.now}
  scope :in_progress, started.not_finished
  scope :not_assigned, joins{assignments.outer}.where{assignments.assignment_plan_id == nil}
  scope :can_be_assigned, not_assigned.in_progress.where{is_ready == true}
  
  def destroyable?
    errors.add(:base, "This assignment cannot be deleted because it has been assigned") \
      if assigned?
    errors.none?
  end
  
  def assigned?
    assignments.any?
    # assignments.any?{|a| a.assigned?}
  end
  
  def active?
    Time.now > starts_at && Time.now < ends_at
  end
  
  def peers
    learning_plan.assignment_plans(true)
  end
  
  # The assignment that starts first is the first plan and has number 0, the one
  # that starts next is the second plan and has number 1, and so on.
  def number
    peers.index{|ap| ap.id == self.id}
  end
  
  def predecessors
    AssignmentPlan.joins{learning_plan}
                  .where{learning_plan.id == my{learning_plan}.id}
                  .where{starts_at.lt my{starts_at}}
                  .order{starts_at.desc}
  end

  def self.build_and_distribute_assignments
    AssignmentPlan.can_be_assigned.each do |assignment_plan|
      cohorts = assignment_plan.learning_plan.klass.cohorts
      
      cohorts.each do |cohort|
        assignment = cohort.learning_condition.build_assignment(assignment_plan)
        assignment.save
      end
    end
  end
      
  #############################################################################
  # Access control methods
  #############################################################################
  
  def can_be_read_by?(user)
    learning_plan.can_be_read_by?(user)
  end
    
  def can_be_created_by?(user)
    learning_plan.can_be_updated_by?(user)
  end
  
  def can_be_updated_by?(user)
    learning_plan.can_be_updated_by?(user)
  end
  
  def can_be_destroyed_by?(user)
    learning_plan.can_be_updated_by?(user)
  end
  
end
