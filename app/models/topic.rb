class Topic < ActiveRecord::Base
  belongs_to :learning_plan
  has_many :topic_exercises, :dependent => :destroy
  has_many :assignment_topics, :dependent => :destroy
  has_many :assignments, :through => :assignment_topics
  
  before_destroy :destroyable?  
  
  acts_as_numberable :container => :learning_plan
  
  attr_accessible :name
  
  def destroyable?
    raise NotYetImplemented
  end
end
