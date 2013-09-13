class LearningConditionPresentationCondition < ActiveRecord::Base
  belongs_to :learning_condition
  belongs_to :presentation_condition

  attr_accessible :learning_condition

  acts_as_numberable :container => :learning_condition

  def self.standard_practice_learning_condition_presentation_condition
    LearningConditionPresentationCondition.new do |lcpc|
      lcpc.presentation_condition = PresentationCondition.standard_practice_presentation_condition
    end
  end

  def self.default_learning_condition_presentation_condition
    LearningConditionPresentationCondition.new do |lcpc|
      lcpc.presentation_condition = PresentationCondition.default_presentation_condition
    end
  end

end
