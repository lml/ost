class LearningPlan < ActiveRecord::Base
  belongs_to :klass
  has_many :topics, :dependent => :destroy, :order => :number
  has_many :assignment_plans, :dependent => :destroy, :order => :starts_at
  has_many :concepts, :dependent => :destroy, :order => :number
  
  validates :klass_id, :presence => true
  validates :name, :presence => true
  
  before_destroy :destroyable?
  
  attr_accessible :description, :name
  
  def destroyable?
    true # depends on children freaking out if they shouldn't be destroyed
  end
  
  #############################################################################
  # Access control methods
  #############################################################################
  
  def can_be_read_by?(user)
    klass.can_be_read_by?(user)
  end
    
  def can_be_created_by?(user)
    raise IllegalOperation # Don't know if this should ever really be called
  end
  
  def can_be_updated_by?(user)
    klass.can_be_updated_by?(user)
  end
  
  def can_be_destroyed_by?(user)
    klass.can_be_destroyed_by?(user)
  end
  
  def children_can_be_read_by?(user, children_symbol)
    case children_symbol
    when :concepts
      can_be_read_by?(user) || user.is_administrator?
    end
  end
  
  
end
