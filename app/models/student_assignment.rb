class StudentAssignment < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :student
  has_many :student_exercises, :dependent => :destroy
  
  before_destroy :destroyable?
  
  attr_accessible
  
  def destroyable?
    raise NotYetImplemented
  end
end
