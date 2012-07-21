class Student < ActiveRecord::Base
  belongs_to :user
  belongs_to :cohort
  has_many :student_assignments, :dependent => :destroy
  
  before_destroy :destroyable?

  validates :cohort_id, :presence => true
  validates :user_id, :presence => true, :uniqueness => {:scope => :cohort_id}

  attr_accessible :is_auditing #, :user_id, :cohort_id

protected

  def destroyable?
    raise NotYetImplemented
    false
  end
    
end
