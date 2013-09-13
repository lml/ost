class LearningConditionFeedbackCondition < ActiveRecord::Base
  belongs_to :learning_condition
  belongs_to :feedback_condition

  attr_accessible :learning_condition

  acts_as_numberable :container => :learning_condition

  def self.standard_practice_learning_condition_feedback_condition
    LearningConditionFeedbackCondition.new do |lcfc|
      lcfc.feedback_condition = BasicFeedbackCondition.standard_practice_feedback_condition
    end
  end

  def self.default_learning_condition_feedback_condition
    LearningConditionFeedbackCondition.new do |lcfc|
      lcfc.feedback_condition = BasicFeedbackCondition.default_feedback_condition
    end
  end

end
