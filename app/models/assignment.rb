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
  
  before_destroy :destroyable?
  
  attr_accessor :dry_run
  
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
    cohort.is_active_member?(user) || Researcher.is_one?(user) || user.is_administrator?
  end

  def can_be_updated_by?(user)
    cohort.klass.is_educator?(user)
  end

end
