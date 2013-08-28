# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class Cohort < ActiveRecord::Base
  belongs_to :klass
  belongs_to :section
  has_many :students, :dependent => :nullify
  has_one :learning_condition, :dependent => :destroy
  has_many :assignments
  
  validates :klass_id, :presence => :true
  validate :section_unchanged?, :on => :update
  validate :klass_unchanged?, :on => :update

  before_create :init_learning_condition
  before_destroy :destroyable?
  
  acts_as_numberable :container => :klass
  
  attr_accessible :section, :klass, :name, :section_id
  
  def name
    true_name = read_attribute(:name)
    true_name.blank? ? "Cohort #{number}" : true_name
  end
  
  def get_student(user)
    students.where{user_id == user.id}.first
  end
  
  def is_student?(user)
    Cohort.joins{students.user}.where{students.user_id == user.id}.any?
  end

  def is_active_student?(user)
    students.where{user_id == user.id}.where{has_dropped == false}.any?
  end
  
  def is_educator?(user)
    Cohort.joins{klass.educators}.where{klass.educators.user_id == user.id}.any?
  end
  
  def is_member?(user)
    is_student?(user) || is_educator?(user)
  end

  def is_active_member?(user)
    is_active_student?(user) || is_educator?(user)
  end
  
  #############################################################################
  # Access control methods
  #############################################################################

  # Cohorts are always mostly invisible to educators (they are mostly 
  # a research tool).  An exception might be telling educators which
  # students are in which cohorts to let people know which groups they
  # can work in.

  def can_be_read_by?(user)
    can_anything?(user)
  end

  def can_be_created_by?(user)
    can_anything?(user)
  end

  def can_be_updated_by?(user)
    can_anything?(user)  
  end

  def can_be_destroyed_by?(user)
    can_anything?(user)
  end
  
  def children_can_be_read_by?(user, children_symbol)
    case children_symbol
    when :students
      can_anything?(user)
    when :learning_condition
      (klass.is_controlled_experiment ? Researcher.is_one?(user) : klass.is_instructor?(user)) || 
      user.is_administrator?
    when :assignments
      klass.is_teacher?(user) || klass.is_active_student?(user) || Researcher.is_one?(user) || user.is_administrator?
    end
  end
  
  def can_anything?(user)
    (klass.is_controlled_experiment ? Researcher.is_one?(user) : klass.is_teaching_assistant?(user)) || 
    user.is_administrator?
  end
  
protected

  def destroyable?
    errors.add(:base, "Cannot delete this cohort because it has students") if students.any?
    errors.add(:base, "Cannot delete this cohort because it has assignments") if assignments.any?
    errors.none?
  end
  
  def init_learning_condition
    self.learning_condition = LearningCondition.new
  end
  
  def section_unchanged?
    errors.add(:section_id, "cannot be changed") if section_id_was != section_id
    errors.none?
  end
  
  def klass_unchanged?
    errors.add(:klass_id, "cannot be changed") if klass_id_was != klass_id
    errors.none?
  end
end
