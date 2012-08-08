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
  
  attr_accessible :ends_at, :introduction, :is_group_work_allowed, :is_open_book, 
                  :is_ready, :is_test, :learning_plan_id, :name, :starts_at, :learning_plan
  
  scope :non_tests, where(:is_test => false)
  scope :tests, where(:is_test => true)
  
  def destroyable?
    errors.add(:base, "This assignment cannot be deleted because it has been assigned") \
      if assigned?
    errors.none?
  end
  
  def assigned?
    assignments.any?{|a| a.assigned?}
  end
  
  def peers
    learning_plan.assignment_plans
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
    latest_end = peers.blank? ? nil : peers.collect{|p| p.ends_at}.max

    self.starts_at = latest_end.nil? ? learning_plan.learning_plannable.start_date : latest_end
    self.ends_at = self.starts_at + 7.days

    if self.ends_at > learning_plan.learning_plannable.end_date
      self.ends_at = learning_plan.learning_plannable.end_date
      self.starts_at = self.ends_at - 7.days
      
      if self.starts_at < learning_plan.learning_plannable.start_date
        self.starts_at = learning_plan.learning_plannable.start_date
      end
    end
  end
  
  def start_and_end_in_bounds
    errors.add(:starts_at, "This assignment cannot start before its class starts.") \
      if starts_at < learning_plan.learning_plannable.start_date
        
    errors.add(:ends_at, "This assignment cannot end after its class ends.") \
      if ends_at > learning_plan.learning_plannable.end_date

    errors.none?
  end
  
  
end
