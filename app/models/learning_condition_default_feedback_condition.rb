class LearningConditionDefaultFeedbackCondition < ActiveRecord::Base
  belongs_to :learning_condition
  belongs_to :feedback_condition, dependent: :destroy

  accepts_nested_attributes_for :feedback_condition

  attr_accessible :feedback_condition_attributes

  def self.default_learning_condition_feedback_condition
    LearningConditionDefaultFeedbackCondition.new do |lcdfc|
      lcdfc.feedback_condition = FeedbackCondition.default_feedback_condition
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