class AssignmentTopic < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :topic
  
  validates :assignment_id, :presence => true
  validates :topic_id, :presence => true, :uniqueness => {:scope => :assignment_id}
  
  attr_accessible :assignment, :topic_id
  
  before_destroy :destroyable?
  
  def destroyable?
    self.errors.add(:base, "This topic cannot be removed from its assignment because the assignment has been issued.") \
      if assignment.student_assignments.any?
    self.errors.none?
  end
  
  #############################################################################
  # Access control methods
  #############################################################################
  
  def can_be_read_by?(user)
    assignment.can_be_read_by?(user)
  end
    
  def can_be_created_by?(user)
    assignment.can_be_updated_by?(user)
  end
  
  def can_be_updated_by?(user)
    assignment.can_be_updated_by?(user)
  end
  
  def can_be_destroyed_by?(user)
    assignment.can_be_updated_by?(user)
  end
  

end
