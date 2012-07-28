class Cohort < ActiveRecord::Base
  belongs_to :klass
  belongs_to :section
  has_many :students, :dependent => :nullify
  has_one :learning_condition, :dependent => :destroy
  
  validates :klass_id, :presence => :true

  before_create :init_learning_condition
  before_destroy :destroyable?
  
  acts_as_numberable :container => :klass
  
  attr_accessible :section
  
  def name
    name.blank? ? "Cohort #{number}" : name
  end
  
  #############################################################################
  # Access control methods
  #############################################################################

  # Cohorts are always mostly invisible to educators (they are mostly 
  # a research tool).  An exception might be telling educators which
  # students are in which cohorts to let people know which groups they
  # can work in.

  def can_be_read_by?(user)
    Researcher.is_one?(user) || user.is_administrator?
  end

  def can_be_created_by?(user)
    Researcher.is_one?(user) || user.is_administrator?
  end

  def can_be_updated_by?(user)
    Researcher.is_one?(user) || user.is_administrator?
  end

  def can_be_destroyed_by?(user)
    Researcher.is_one?(user) || user.is_administrator?
  end
  
  def children_can_be_read_by?(user, children_symbol)
    case children_symbol
    when :students
      Researcher.is_one?(user) || user.is_administrator?
    end
  end
  
protected

  def destroyable?
    raise NotYetImplemented
  end
  
  def init_learning_condition
    self.learning_condition = LearningCondition.new
  end
end
