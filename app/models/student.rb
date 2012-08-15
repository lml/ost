class Student < ActiveRecord::Base
  belongs_to :user
  belongs_to :cohort
  belongs_to :section
  has_many :student_assignments, :dependent => :destroy
  has_one :consent, :as => :consentable, :dependent => :destroy
  
  before_destroy :destroyable?

  validates :section_id, :presence => true
  validates :user_id, :presence => true, :uniqueness => {:scope => :cohort_id}

  attr_accessible :is_auditing , :user_id, :section_id, :student_specified_id, :has_dropped
  
  scope :auditing, where(:is_auditing => true)
  scope :registered, where(:is_auditing => false)
  scope :active, where(:has_dropped => false)
  scope :dropped, where(:has_dropped => true)
  scope :consented, joins(:consent).where(:consent => {:did_consent.eq => true})

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

  def consented?
    !consent.nil? && consent.did_consent
  end
  
  def is_consentable_for_user?(user)
    user.id == self.user_id
  end
  
  def not_currently_consentable?
    # Auditing students are not included in informed consent research
    auditing || 
    # Haven't consented but no consent form available to consent to
    (consent.nil? && consent_options.consent_form_id.nil?) || 
    # There is a consent form but the consenting window isn't open
    (!consent_options.consent_form_id.nil? && !consent_options.consenting_is_open?) 
  end
  
  def consent_options
    section.klass.consent_options
  end
  
  def options_for_new_consent
    consent_options
  end
  
  def name_for_consent
    section.klass.course.name
  end

  #############################################################################
  # Access control methods
  #############################################################################

  def can_be_read_by?(user)
    user.id == user_id || section.klass.is_educator?(user) || Researcher.is_one?(user) || user.is_administrator?
  end

  def can_be_updated_by?(user)
    section.klass.is_teaching_assistant?(user) || user.is_administrator?
  end

protected

  def destroyable?
    raise NotYetImplemented
    false
  end
    
end
