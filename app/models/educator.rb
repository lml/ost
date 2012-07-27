class Educator < ActiveRecord::Base
  belongs_to :klass
  belongs_to :user
  
  validates :klass_id, :presence => true
  validates :user_id, :presence => true, :uniqueness => {:scope => :klass_id}
  
  attr_accessible :is_grader, :is_instructor, :is_teaching_assistant, :klass_id, :user_id, :user, :klass
  
  #############################################################################
  # Access control methods
  #############################################################################
  
  def can_be_read_by?(user)
    user.can_read?(klass)
  end
    
  def can_be_created_by?(user)
    user.is_administrator? || klass.is_instructor?(user)
  end
  
  def can_be_destroyed_by?(user)
    user.is_administrator? || user.id == user_id || klass.is_instructor?(user)
  end
  
end
