class Researcher < ActiveRecord::Base
  belongs_to :user
  
  validates :user_id, :presence => true, :uniqueness => true
  validate :not_a_registered_student
    
  attr_accessible
  
  def self.is_one?(user)
    user.is_researcher?
  end
  
  #############################################################################
  # Access control methods
  #############################################################################

  def can_be_read_by?(user)
    user.is_administrator?
  end
    
  def can_be_created_by?(user)
    user.is_administrator?
  end
  
  def can_be_updated_by?(user)
    user.is_administrator?
  end
  
  def can_be_destroyed_by?(user)
    user.is_administrator?
  end
  
protected

  def not_a_registered_student
    return true if Student.where(:user_id => user.id, :is_auditing => false).none?
    errors.add(:base, "This researcher cannot be created because he/she is a registered student.")
    false
  end
  
end
