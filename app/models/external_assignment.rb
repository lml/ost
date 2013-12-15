class ExternalAssignment < ActiveRecord::Base
  belongs_to :klass
  has_many :external_assignment_exercises,  dependent: :destroy
  has_many :student_external_assignments,   dependent: :destroy

  acts_as_numberable container: :klass

  attr_accessible :klass,
                  :external_assignment_exercises,
                  :student_external_assignments,
                  :name

  def can_be_read_by?(user)
    klass.is_educator?(user) || user.is_researcher? || user.is_administrator?
  end
    
  def can_be_created_by?(user)
    klass.is_teacher?(user) || user.is_administrator?
  end
  
  def can_be_updated_by?(user)
    klass.is_teacher?(user) || user.is_administrator?
  end
  
  def can_be_destroyed_by?(user)
    klass.is_teacher?(user) || user.is_administrator?
  end
  
  def can_be_sorted_by?(user)
    can_be_updated_by?(user)
  end

  def children_can_be_read_by?(user, children_symbol)
    case children_symbol
    when :external_assignment_exercises
      klass.is_educator?(user) || user.is_researcher? || user.is_administrator?
    end
  end

end
