class CourseInstructor < ActiveRecord::Base
  belongs_to :course
  belongs_to :user
  
  validates :course_id, :presence => true
  validates :user_id, :presence => true, :uniqueness => {:scope => :course_id}
  
  attr_accessible :course_id, :user_id, :course
  
  def name
    user.full_name
  end
  
  #############################################################################
  # Access control methods
  #############################################################################
  
  def can_be_read_by?(user)
    true
  end
    
  def can_be_created_by?(user)
    user.is_administrator? # TODO and eventually organization managers
  end
  
  def can_be_updated_by?(user)
    user.is_administrator?
  end
  
  def can_be_destroyed_by?(user)
    user.is_administrator?
  end
  
end
