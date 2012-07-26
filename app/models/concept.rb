class Concept < ActiveRecord::Base
  belongs_to :learning_plan
  has_many :topic_exercises
  
  validates :learning_plan_id, :presence => true
  validates :name, :presence => true, :uniqueness => {:scope => :learning_plan_id}
  
  acts_as_numberable :container => :learning_plan
  
  before_destroy :destroyable?
  
  attr_accessible :name
  
  def destroyable?
    raise NotYetImplemented
  end
end
