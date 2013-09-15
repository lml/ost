class LearningConditionDefaultPresentationCondition < ActiveRecord::Base
  belongs_to :learning_condition
  belongs_to :presentation_condition, dependent: :destroy

  accepts_nested_attributes_for :presentation_condition

  attr_accessible :presentation_condition_attributes

  #############################################################################
  # Access control methods
  #############################################################################

  def can_be_read_by?(user)
    can_anything?(user)
  end

  def can_be_created_by?(user)
    can_anything?(user)
  end

  def can_be_updated_by?(user)
    can_anything?(user)
  end

  def can_be_destroyed_by?(user)
    can_anything?(user)
  end
  
  def can_be_sorted_by?(user)
    can_anything?(user)
  end
  
  def can_anything?(user)
    learning_condition.can_anything?(user)
  end

end
