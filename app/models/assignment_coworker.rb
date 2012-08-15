class AssignmentCoworker < ActiveRecord::Base
  belongs_to :student_assignment
  belongs_to :student

  validates :student_assignment_id, :presence => true
  validates :student_id, :presence => true,
                         :uniqueness => {:scope => :student_assignment_id}

  validate :same_cohort
  validate :same_auditing_status

  attr_accessible

  def owned_by?(user)
    !user.is_anonymous? && student_assignment.student.user_id == user.id
  end

  #############################################################################
  # Access control methods
  #############################################################################

  def can_be_created_by?(user)
    owned_by?(user) && student_assignment.assignment.assignment_plan.group_work_allowed
  end

  def can_be_destroyed_by?(user)
    owned_by?(user)
  end

protected

  def same_cohort
    return true if student_assignment.student.cohort_id == student.cohort_id
    errors.add(:base, "Coworkers must be in the same cohort")
    false
  end

  def same_auditing_status
    return true if student_assignment.student.auditing == student.auditing
    errors.add(:base, "Coworkers must have the same auditing status")
    false
  end




end
