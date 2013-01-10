class FreeResponse < ActiveRecord::Base

  belongs_to :student_exercise

  mount_uploader :attachment, FreeResponseUploader

  attr_accessible :attachment, :content, :content_type, :student_exercise_id

  validates :student_exercise_id, :presence => true
  validates :type, :presence => true
  validate :updatable?

  def can_be_read_by?(user)
    user.can_read?(student_exercise)
  end
    
  def can_be_created_by?(user)
    user.can_update?(student_exercise)
  end
  
  def can_be_updated_by?(user)
    user.can_update?(student_exercise)
  end
  
  def can_be_destroyed_by?(user)
    user.can_update?(student_exercise)
  end

  def updatable?
    student_exercise.free_responses_can_be_updated?
  end

end
