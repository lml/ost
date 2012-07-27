class Course < ActiveRecord::Base
  belongs_to :organization
  has_many :course_instructors, :dependent => :destroy
  has_many :klasses, :dependent => :destroy
  
  validates :organization_id, :presence => true
  validates :name, :presence => true, :uniqueness => {:scope => :organization_id}
  
  acts_as_numberable :container => :organization
  
  attr_accessible :description, :name, :typically_offered
  
  def is_instructor?(user)
    course_instructors.any?{|ci| ci.user_id == user.id}
  end
  
  #############################################################################
  # Access control methods
  #############################################################################
  
  def can_be_read_by?(user)
    true
  end
    
  def can_be_created_by?(user)
    user.is_administrator?
  end
  
  def can_be_updated_by?(user)
    user.is_administrator?
  end
  
  def can_be_destroyed_by?(user)
    user.is_administrator?
  end

end
