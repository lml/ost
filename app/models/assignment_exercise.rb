class AssignmentExercise < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :topic_exercise
  has_many :student_exercises
  
  # only checking for the assignment_id on update so that we can build up an
  # entire assignment and save it all together (assignment gets saved last, so
  # the assignment ID doesn't exist in time to be approved by this validation)
  validates :assignment_id, :presence => true, :on => :update
  validates :topic_exercise_id, :presence => true, :uniqueness => {:scope => :assignment_id}
  
  before_destroy :destroyable?
  
  acts_as_numberable :container => :assignment
  
  attr_accessible :assignment, :topic_exercise, :assignment_id
    
  def destroyable?
    raise NotYetImplemented
  end
end
