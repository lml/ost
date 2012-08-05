class Concept < ActiveRecord::Base
  belongs_to :learning_plan
  has_many :topic_exercises
  
  validates :learning_plan_id, :presence => true
  validates :name, :presence => true, :uniqueness => {:scope => :learning_plan_id}
  
  acts_as_numberable :container => :learning_plan
  
  before_destroy :destroyable?
  
  attr_accessible :name, :learning_plan
  
  def destroyable?
    return true if topic_exercises.none?
    errors.add(:base, "This concept cannot be deleted because it is attached to exercises.")
    false
  end
  
  def editable?
    topic_exercises.none?
  end
  
  #############################################################################
  # Access control methods
  #############################################################################

  def can_be_read_by?(user)
    learning_plan.can_be_read_by?(user)
  end

  def can_be_created_by?(user)
    learning_plan.can_be_updated_by?(user)
  end

  def can_be_updated_by?(user)
    learning_plan.can_be_updated_by?(user) && editable?
  end

  def can_be_destroyed_by?(user)
    learning_plan.can_be_updated_by?(user) && destroyable?
  end
  
  def can_be_sorted_by?(user)
    can_be_updated_by?(user)
  end  
  
end
