class Student < ActiveRecord::Base
  belongs_to :user
  belongs_to :cohort
  belongs_to :section
  has_many :student_assignments, :dependent => :destroy
  has_one :consent, :as => :consentable, :dependent => :destroy
  
  before_create :assign_to_cohort
  
  before_destroy :destroyable?
  
  before_validation :handle_section_change, :on => :update

  validates :section_id, :presence => true
  validates :user_id, :presence => true, :uniqueness => {:scope => :cohort_id}

  attr_accessible :is_auditing , :user_id, :section_id, :student_specified_id, :has_dropped
  
  scope :auditing, where(:is_auditing => true)
  scope :registered, where(:is_auditing => false)
  scope :active, where(:has_dropped => false)
  scope :dropped, where(:has_dropped => true)
  scope :consented, joins{consent}.where{consent.did_consent == true}
  
  scope :visible, lambda { |user| 
    if user.is_researcher? || user.is_visitor?
      consented
    else
      scoped
    end
  }
  
  scope :same_kind_as, lambda { |student| 
    student.registered? ? registered : auditing
  }

  scope :std_sort, lambda { |user_arg| 
    if user_arg.is_researcher? || user_arg.is_visitor?
      joins{user}.order{user.research_id.asc}
      # order(:user => :research_id.asc).joins(:user)
    else
      joins{user}.order{user.last_name.asc}
      # order(:user => :last_name.asc).joins(:user)
    end
  }

  def full_name(requesting_user)
    if can_view_name?(requesting_user)
      if student_specified_id.blank?
        user.full_name
      else
        if requesting_user.is_administrator?
          "#{user.full_name} (#{student_specified_id})"
        else
          student_specified_id
        end
      end
    else
      user.research_id
    end
  end
  
  def can_view_name?(user)
    :force == user || true == is_auditing || !Researcher.is_one?(user) || user_id == user.id
  end
  
  def auditing?
    is_auditing
  end
  
  def registered?
    !is_auditing
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
    is_auditing || 
    # Haven't consented but no consent form available to consent to
    (consent.nil? && consent_options.consent_form_id.nil?) || 
    # There is a consent form but the consenting window isn't open
    (!consent_options.consent_form_id.nil? && !consent_options.consenting_is_open?) 
  end
  
  def currently_consentable?
    !not_currently_consentable?
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
  
  def children_can_be_read_by?(user, children_symbol)
    case children_symbol
    when :student_assignments
      return section.klass.is_educator?(user) || Researcher.is_one?(user) || user.is_administrator?
    end
    false
  end
  

protected

  def destroyable?
    raise NotYetImplemented
    false
  end
  
  def assign_to_cohort
    # When a new student registers for a section, she will be added to the cohort with 
    # the fewest members.  If there is more than one cohort with the same number of 
    # fewest members, she will be randomly assigned to one of them.
    # 
    # Our first instinct was that since auditors are not part of the formal research 
    # study, they should not be members of cohorts.  However, this means their 
    # whole OST experience would be broken (because without a cohort, they are not 
    # linked to a learning condition).  So what we do below is assign them to cohorts 
    # as we would any normal registered student.  However, when we're assigning 
    # registered students to cohorts we do not count auditing students already in 
    # cohorts; this way the cohorts will continue to have equal numbers of registered 
    # students. While not totally required, for simplicity when adding auditors we also
    # don't  count registered students. We will also continue to not include auditing 
    # students in the research reports.
        
    cohorts = section.cohorts
    cohorts = section.klass.cohorts if cohorts.empty?

    smallest_cohort_size = cohorts.collect{|c| c.students.same_kind_as(self).count}.min
    candidate_cohorts = cohorts.select{|c| c.students.same_kind_as(self).count == smallest_cohort_size}
    
    target_cohort = candidate_cohorts.sample
    self.cohort = target_cohort
  end
  
  # If someone is trying to change the section, make sure we can do that (haven't)
  # already started work and that we change the cohort too.
  def handle_section_change
    # No action needed if:
    #  a) section didn't change or 
    #  b) the current cohort is not linked to a section and the new section isn't linked to any cohorts
    return true if !section_id_changed? || (cohort.section_id.nil? && section.cohorts.empty?)
    
    if student_assignments.any?
      self.errors.add(:base, "Student cannot be moved because they've already started work in their existing section.")
      return false
    end

    assign_to_cohort
    true
  end
    
end
