class AssignmentExercise < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :topic_exercise
  
  acts_as_numberable :container => :assignment
  
  attr_accessible
end
