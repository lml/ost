class Organization < ActiveRecord::Base
  has_many :courses, :dependent => :destroy
  has_many :organization_managers, :dependent => :destroy
  
  validate :name, :presence => true, :uniqueness => true
  
  before_destroy :assert_no_courses
  
  attr_accessible :default_time_zone, :name
  
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
  
  def children_can_be_read_by?(user, children_symbol)
    case children_symbol
    when :courses
      user.is_administrator?
    else
      false
    end
  end
  
protected

  def assert_no_courses
    return if courses.empty?
    errors.add(:base, "Cannot delete an organization that has courses.")
    false
  end
  
end
