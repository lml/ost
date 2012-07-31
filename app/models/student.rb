class Student < ActiveRecord::Base
  belongs_to :user
  belongs_to :cohort
  belongs_to :section
  has_many :student_assignments, :dependent => :destroy
  
  before_destroy :destroyable?

  validates :section_id, :presence => true
  validates :user_id, :presence => true, :uniqueness => {:scope => :cohort_id}

  attr_accessible :is_auditing , :user_id, :section_id, :student_specified_id, :has_dropped
  
  scope :auditing, where(:is_auditing => true)
  scope :registered, where(:is_auditing => false)
  scope :active, where(:has_dropped => false)
  scope :dropped, where(:has_dropped => true)
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
  
  def active?
    !has_dropped
  end
  
  def has_dropped?
    has_dropped
  end
  
  def drop!
    self.update_attributes({:has_dropped => true})
  end

  #############################################################################
  # Access control methods
  #############################################################################

  def can_be_read_by?(user)
    raise NotYetImplemented
  end

  def can_be_updated_by?(user)
    section.klass.is_teaching_assistant?(user) || user.id == user_id || user.is_administrator?
  end

protected

  def destroyable?
    raise NotYetImplemented
    false
  end
    
end
