class Educator < ActiveRecord::Base
  belongs_to :offered_course
  belongs_to :user
  
  validates :offered_course_id, :presence => true
  validates :user_id, :presence => true, :uniqueness => {:scope => :offered_course_id}
  
  attr_accessible :is_grader, :is_instructor, :is_teaching_assistant, :offered_course_id, :user_id, :user, :offered_course
  
  #############################################################################
  # Access control methods
  #############################################################################
  
  def can_be_read_by?(user)
    user.can_read?(offered_course)
  end
    
  def can_be_created_by?(user)
    user.is_administrator? || offered_course.is_instructor?(user)
  end
  
  def can_be_destroyed_by?(user)
    user.is_administrator? || user.id == user_id || offered_course.is_instructor?(user)
  end
  
end
