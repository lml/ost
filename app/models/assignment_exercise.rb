class AssignmentExercise < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :topic_exercise
  has_many :student_exercises
  
  validates :assignment_id, :presence => true
  validates :topic_exercise_id, :presence => true, :uniqueness => {:scope => :assignment_id}
  
  before_destroy :destroyable?
  
  acts_as_numberable :container => :assignment
  
  attr_accessible
    
  def destroyable?
    raise NotYetImplemented
  end
end
