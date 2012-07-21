class Concept < ActiveRecord::Base
  belongs_to :learning_plan
  has_many :topic_exercises
  
  validate :name, :presence => true, :uniqueness => {:scope => :learning_plan_id}
  
  acts_as_numberable :container => :learning_plan
  
  attr_accessible :name
end
