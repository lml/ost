class LearningPlan < ActiveRecord::Base
  belongs_to :learning_plannable, :polymorphic => true
  has_many :topics, :dependent => :destroy
  has_many :assignments, :dependent => :destroy
  has_many :concepts, :dependent => :destroy
  
  attr_accessible :description, :learning_plannable_id, :learning_plannable_type, :name
end
