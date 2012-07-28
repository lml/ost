class LearningCondition < ActiveRecord::Base
  belongs_to :cohort
  belongs_to :klass # for convenience
  
  attr_accessible :klass_id
  
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
    # If the class is not the subject of formal research, a learning
    # condition is still necessary and needs to be available to the
    # instructors
    
    klass.is_controlled_experiment ? 
      Researcher.is_one?(user) || user.is_administrator? :
      klass.is_instructor(user) || user.is_administrator?
  end
end
