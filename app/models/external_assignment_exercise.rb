class ExternalAssignmentExercise < ActiveRecord::Base
  belongs_to :external_assignment
  has_many   :student_external_assignment_exercises

  acts_as_numberable container: :external_assignment

  attr_accessible :external_assignment,
                  :student_external_assignment_exercises,
                  :name

  def can_be_read_by?(user)
    external_assignment.can_be_read_by?(user)
  end

  def can_be_created_by?(user)
    external_assignment.can_be_created_by?(user)
  end

  def can_be_updated_by?(user)
    external_assignment.can_be_updated_by?(user)
  end

  def can_be_destroyed_by?(user)
    external_assignment.can_be_destroyed_by?(user)
  end

  def can_be_sorted_by?(user)
    can_be_updated_by?(user)
  end

  def children_can_be_read_by?(user, children_symbol)
  end

end
