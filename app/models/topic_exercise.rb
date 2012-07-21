class TopicExercise < ActiveRecord::Base
  belongs_to :concept
  belongs_to :topic
  belongs_to :exercise
  
  before_destroy :destroyable?
  
  acts_as_numberable :container => :topic
  
  attr_accessible
  
  def destroyable?
    raise NotYetImplemented
  end
end
