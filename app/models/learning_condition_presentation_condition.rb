class LearningConditionPresentationCondition < ActiveRecord::Base
  belongs_to :learning_condition
  belongs_to :presentation_condition, dependent: :destroy

  accepts_nested_attributes_for :presentation_condition

  attr_accessible :learning_condition, :presentation_condition

  acts_as_numberable :container => :learning_condition

  def self.standard_practice_learning_condition_presentation_condition
    LearningConditionPresentationCondition.new do |lcpc|
      lcpc.presentation_condition = PresentationCondition.standard_practice_presentation_condition
    end
  end

  def self.new_learning_condition_presentation_condition
    LearningConditionPresentationCondition.new do |lcpc|
      lcpc.presentation_condition = PresentationCondition.new_presentation_condition
    end
  end

  def self.default_learning_condition_presentation_condition
    LearningConditionPresentationCondition.new do |lcpc|
      lcpc.presentation_condition = PresentationCondition.default_presentation_condition
    end
  end

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
