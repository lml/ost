class Student < ActiveRecord::Base
  belongs_to :user
  belongs_to :cohort
  belongs_to :section
  has_many :student_assignments, :dependent => :destroy
  
  before_destroy :destroyable?

  validates :cohort_id, :presence => true
  validates :user_id, :presence => true, :uniqueness => {:scope => :cohort_id}

  attr_accessible :is_auditing #, :user_id, :cohort_id
  
  scope :auditing, where(:is_auditing => true)
  scope :registered, where(:is_auditing => false)
  # scope :consented, joins(:consent).where(:consent => {:did_consent.eq => true})

  def full_name(requesting_user)
    can_view_name?(requesting_user) ? user.full_name : user.research_id
  end
  
  def self.standard_sort(students, requesting_user)
    Researcher.is_one?(requesting_user) ? students.sort_by{|ss| ss.user.research_id} : students.sort_by{|ss| ss.user.last_name}
  end  

  def can_view_name?(user)
    :force == user || true == is_auditing || !Researcher.is_one?(user) || user_id == user.id
  end
  
  def auditing?
    auditing
  end
  
  def registered?
    !auditing
  end

  

protected

  def destroyable?
    raise NotYetImplemented
    false
  end
    
end
