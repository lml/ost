class FreeResponse < ActiveRecord::Base

  belongs_to :student_exercise

  acts_as_numberable :container => :student_exercise,
                     :table_class => FreeResponse

  attr_accessible :attachment, :content, :content_type, :student_exercise_id

  validates :student_exercise_id, :presence => true
  validates :type, :presence => true
  validate :updatable?, :unless => :ignore_updatable_validation

  attr_accessor :ignore_updatable_validation

  def updatable?
    return true if sudo_enabled?
    errors.add(:base, "Cannot add or edit free responses for a turned-in exercise") \
      if !student_exercise.free_responses_can_be_updated?
    errors.none?
  end

  #############################################################################
  # Access control methods
  #############################################################################

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

  def can_be_sorted_by?(user)
    user.can_update?(student_exercise)
  end

end
