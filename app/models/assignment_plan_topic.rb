class AssignmentPlanTopic < ActiveRecord::Base
  belongs_to :assignment_plan
  belongs_to :topic
  
  validates :assignment_plan_id, :presence => true
  validates :topic_id, :presence => true, :uniqueness => {:scope => :assignment_plan_id}
  
  attr_accessible :assignment_plan, :topic_id
  
  before_destroy :destroyable?
  
  def destroyable?
    self.errors.add(:base, "This topic cannot be removed from its assignment because the assignment has been issued.") \
      if assignment_plan.assigned?
    self.errors.none?
  end
  
  #############################################################################
  # Access control methods
  #############################################################################
  
  def can_be_read_by?(user)
    assignment_plan.can_be_read_by?(user)
  end
    
  def can_be_created_by?(user)
    assignment_plan.can_be_updated_by?(user)
  end
  
  def can_be_updated_by?(user)
    assignment_plan.can_be_updated_by?(user)
  end
  
  def can_be_destroyed_by?(user)
    assignment_plan.can_be_updated_by?(user)
  end
  

end
