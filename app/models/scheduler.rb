# Mostly an interface class
class Scheduler < ActiveRecord::Base
  belongs_to :learning_condition
  
  store :settings
  
  attr_accessible :learning_condition
  
  def build_assignment(assignment_plan, cohort)
    raise AbstractMethodCalled
  end
  
  #############################################################################
  # Access control methods
  #############################################################################

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
  
  def can_anything?(user)
    learning_condition.can_anything?(user)
  end
end