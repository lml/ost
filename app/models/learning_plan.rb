class LearningPlan < ActiveRecord::Base
  attr_accessible :description, :learning_plannable_id, :learning_plannable_type, :name
end
