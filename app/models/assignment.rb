class Assignment < ActiveRecord::Base
  belongs_to :assignment_plan
  belongs_to :cohort
  has_many :student_assignments, :dependent => :destroy
  has_many :assignment_exercises, :dependent => :destroy
  
  attr_accessible :assignment_plan, :cohort
  
  before_destroy :destroyable?
  
  def destroyable?
    # TODO eventually might allow destruction if sudo enabled
    errors.add(:base, "This assignment cannot be deleted because it has been given out to students") \
      if assigned?
    errors.none?
  end
  
  def assigned?
    student_assignments.any?
  end
end
