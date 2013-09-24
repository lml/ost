# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

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
  
  before_destroy :destroyable?, prepend: true
  
  attr_accessor :dry_run
  
  def klass
    cohort.klass
  end

  def get_student(user)
    Student.where{user_id == my{user.id}}.joins{student_assignments}.where{student_assignments.assignment_id == my{id}}.first
  end

  def add_topic_exercise(topic_exercise, tags)
    assignment_exercise = AssignmentExercise.new(:topic_exercise => topic_exercise)
    assignment_exercise.add_tags(tags)
    self.assignment_exercises << assignment_exercise
  
    # We must manually set the number since we keep adding them without saving them
    # (if we don't do this they'll all have number 1)
    assignment_exercise.number = assignment_exercises.size
  end
  
  def check_has_exercises
    errors.add(:base, "All assignments must have at least one exercise") if assignment_exercises.none?
  end
  
  def destroyable?
    return true if sudo_enabled?
    errors.add(:base, "This assignment cannot be deleted because it has been given out to students (except by admin override)") \
      if assigned?
    errors.none?
  end
  
  def assigned?
    student_assignments(true).any?
  end

  def active?
    assignment_plan.active?
  end

  def self.create_missing_student_assignments
    Assignment.find_each do |assignment|
      assignment.create_missing_student_assignments
    end
  end

  def create_missing_student_assignments
    cohort.students.active.find_each do |student|
      student_assignment = StudentAssignment.for_student(student).for_assignment(self).first
      if student_assignment.nil?
        student_assignment = StudentAssignment.new(:student_id    => student.id, 
                                                   :assignment_id => self.id)
        student_assignment.save!
      end
    end
  end

  #############################################################################
  # Access control methods
  #############################################################################

  def can_be_read_by?(user)
    return !klass.closed? if is_active_assignment_recipient?(user) || is_educator?(user)
    return true           if user.is_researcher?
    return true           if user.is_administrator?
    return false
  end

  def can_be_updated_by?(user)
    cohort.klass.is_teacher?(user)
  end

  def children_can_be_read_by?(user, children_symbol)
    case children_symbol
    when :grades
      cohort.klass.is_educator?(user) || user.is_researcher? || user.is_administrator?
    end
  end

  def is_active_assignment_recipient?(user)
    student = get_student(user)
    return student.active? if student.present?
    return false
  end

  def is_educator?(user)
    klass.is_educator?(user)
  end
end
