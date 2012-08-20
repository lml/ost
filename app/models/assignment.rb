class Assignment < ActiveRecord::Base
  belongs_to :assignment_plan
  belongs_to :cohort
  has_many :student_assignments, :dependent => :destroy
  has_many :assignment_exercises, :order => :number, :dependent => :destroy

  validates :assignment_plan_id, :presence => true
  validates :cohort_id, :presence => true,
                        :uniqueness => {:scope => :assignment_plan_id}                    

  # Commented this out b/c do we really care?
  # validate :check_has_exercises, :on => :create
  
  attr_accessible :assignment_plan, :cohort, :assignment_exercises_attributes
  
  accepts_nested_attributes_for :assignment_exercises
  
  before_destroy :destroyable?
  
  attr_accessor :dry_run
  
  def check_has_exercises
    errors.add(:base, "All assignments must have at least one exercise") if assignment_exercises.none?
  end
  
  def destroyable?
    # TODO eventually might allow destruction if sudo enabled
    errors.add(:base, "This assignment cannot be deleted because it has been given out to students") \
      if assigned?
    errors.none?
  end
  
  def assigned?
    student_assignments.any?
  end

  def active?
    assignment_plan.active?
  end

  #############################################################################
  # Access control methods
  #############################################################################

  def can_be_read_by?(user)
    cohort.is_member?(user) || Researcher.is_one?(user)
  end

  def can_be_updated_by?(user)
    cohort.klass.is_educator?(user)
  end

end
