class AssignmentPlan < ActiveRecord::Base
  belongs_to :learning_plan
  has_many :assignments, :dependent => :destroy
  has_many :assignment_plan_topics, :dependent => :destroy
  has_many :topics, :through => :assignment_plan_topics

  # These move over to assignment.rb
  # has_many :student_assignments, :dependent => :destroy
  # has_many :assignment_exercises, :dependent => :destroy, :order => :number
  
  before_destroy :destroyable?
  
  before_validation :initialize_start_end, :on => :create
  
  validates :name, :presence => true, :uniqueness => {:scope => :learning_plan_id}
  validates :starts_at, :presence => true
  validates :ends_at, :presence => true, :date => {:after => :starts_at}
  validate :start_and_end_in_bounds
  validates :max_num_exercises, :allow_nil => true, :numericality => { :greater_than_or_equal_to => 0 }
  
  attr_accessible :ends_at, :introduction, :is_group_work_allowed, :is_open_book, 
                  :is_ready, :is_test, :learning_plan_id, :name, :starts_at, :learning_plan
  
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
  
protected

  def initialize_start_end  
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
  
  def start_and_end_in_bounds
    errors.add(:starts_at, "This assignment cannot start before its class starts.") \
      if starts_at < learning_plan.klass.start_date
        
    errors.add(:ends_at, "This assignment cannot end after its class ends.") \
      if ends_at > learning_plan.klass.end_date

    errors.none?
  end
  
  
end
