class StudentAssignment < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :student
  has_many :student_exercises, :dependent => :destroy
  
  before_destroy :destroyable?
  
  validates :assignment_id, :presence => true
  validates :student_id, :presence => true, :unique => {:scope => :assignment_id}
  
  attr_accessible
  
  def destroyable?
    raise NotYetImplemented
  end
end
