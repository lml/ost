# Copyright 2011-2014 Rice University. Licensed under the Affero General Public
# License version 3 or later.  See the COPYRIGHT file for details.

class AssignmentExercise < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :topic_exercise
  has_many :student_exercises, :dependent => :destroy
  
  acts_as_taggable
  
  # only checking for the assignment_id on update so that we can build up an
  # entire assignment and save it all together (assignment gets saved last, so
  # the assignment ID doesn't exist in time to be approved by this validation)
  validates :assignment_id, :presence => true, :on => :update
  validates :topic_exercise_id, :presence => true, :uniqueness => {:scope => :assignment_id}
  
  before_destroy :destroyable?, prepend: true
  
  acts_as_numberable :container => :assignment
  
  attr_accessible :assignment, :topic_exercise, :assignment_id

  def destroyable?
    return true if sudo_enabled?
    errors.add(:base, "This assignment exercise cannot be deleted because it has already been distributed to students (except by admin override)") \
      if student_exercises(true).any?
    errors.none?
  end
  
  # Expects comma-delimted tags, eg. "tag1, tag2"
  def add_tags(tags)
    tag_list.add(tags, :parse => true) if !tags.blank?
  end
  
  def has_tag?(tag)
    tag_list.include?(tag.downcase)
  end
  

  # Get the list of student exercises:
  #  - sorted   by student
  #  - grouped  by student status
  #  - filtered by visibility for present_user
  def exercises_by_student_status(present_user)
    # Get students
    # sort, filter and group students
    # Get assignments for the students
    students = Student.joins{student_assignments}
                      .where{student_assignments.assignment_id == my{assignment.id}}
    students = students.visible(present_user)
    registered = students.registered.active.std_sort(present_user)
    auditing = students.auditing.active.std_sort(present_user)
    dropped = students.dropped.std_sort(present_user)

    registered_ex = student_exercises.joins(:student_assignment)
                                     .where(student_assignment: {student_id: registered})

    auditing_ex = student_exercises.joins(:student_assignment)
                                     .where(student_assignment: {student_id: auditing})

    dropped_ex = student_exercises.joins(:student_assignment)
                                     .where(student_assignment: {student_id: dropped})


    {:registered => registered_ex, :auditing => auditing_ex, :dropped => dropped_ex}
  end


  #############################################################################
  # Access control methods
  #############################################################################
  def can_be_read_by?(user)
    !user.is_anonymous? && (user.is_administrator? ||
                            user.is_researcher?    ||
                            assignment.is_educator?(user))
  end

end
