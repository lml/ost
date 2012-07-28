class Educator < ActiveRecord::Base
  belongs_to :klass
  belongs_to :user
  
  validates :klass_id, :presence => true
  validates :user_id, :presence => true, :uniqueness => {:scope => :klass_id}
  validate :has_one_type
  
  attr_accessible :is_grader, :is_instructor, :is_teaching_assistant, :klass_id, :user_id, :user, :klass

  scope :instructors, where{{is_instructor => true}}  
  scope :teaching_assistants, where{{is_teaching_assistant => true}}
  scope :graders, where{{is_grader => true}}
  
  attr_accessor :type
  
  #############################################################################
  # Access control methods
  #############################################################################
  
  def can_be_read_by?(user)
    user.can_read?(klass)
  end
    
  def can_be_created_by?(user)
    user.is_administrator? || klass.is_instructor?(user)
  end
  
  def can_be_destroyed_by?(user)
    user.is_administrator? || user.id == user_id || klass.is_instructor?(user)
  end
  
protected

  def has_one_type
    errors.add(:base, 'All educators must be one of an instructor, a TA, or a grader.') \
      if !(is_instructor ^ is_teaching_assistant ^ is_grader)
    errors.empty?
  end
  
end
