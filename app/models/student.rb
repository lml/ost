class Student < ActiveRecord::Base
  belongs_to :user
  belongs_to :cohort
  has_many :student_assignments, :dependent => :destroy
  
  before_destroy :destroyable?
  
  attr_accessible :cohort_id, :is_auditing, :user_id

protected

  def destroyable?
    raise NotYetImplemented
    false
  end
    
end
