# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class Organization < ActiveRecord::Base
  has_many :courses, :dependent => :destroy, :order => :number
  has_many :organization_managers, :dependent => :destroy
  
  validates :name, :presence => true, :uniqueness => true

  before_destroy :assert_no_courses, prepend: true
  
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
    return if courses(true).empty?
    errors.add(:base, "Cannot delete an organization that has courses.")
    false
  end
  
end
