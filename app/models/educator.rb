# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class Educator < ActiveRecord::Base
  belongs_to :klass
  belongs_to :user
  
  before_validation :convert_type
  
  validates :klass_id, :presence => true
  validates :user_id, :presence => true, :uniqueness => {:scope => :klass_id}
  validate :has_one_type
  
  after_validation :log_errors
  
  attr_accessible :is_grader, :is_instructor, :is_teaching_assistant, :klass_id, :user_id, :user, :klass, :type

  scope :instructors, where{{is_instructor => true}}  
  scope :teaching_assistants, where{{is_teaching_assistant => true}}
  scope :graders, where{{is_grader => true}}
  
  attr_accessor :type
  
  def type
    return "instructor" if is_instructor
    return "teaching_assistant" if is_teaching_assistant
    return "grader" if is_grader
  end
  
  # def type=(type)
  #   self.is_instructor = true if type == 'instructor' 
  #   self.is_teaching_assistant = true if type == 'teaching_assistant'
  #   self.is_grader = true if type == 'grader'
  # end
  
  #############################################################################
  # Access control methods
  #############################################################################
  
  def can_be_read_by?(user)
    user.can_read?(klass)
  end
    
  def can_be_created_by?(user)
    user.is_administrator? || klass.is_instructor?(user)
  end

  def can_be_updated_by?(user)
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
  
  def convert_type
    return if @type.nil?
    self.is_instructor = @type == 'instructor'
    self.is_teaching_assistant = @type == 'teaching_assistant'
    self.is_grader = @type == 'grader'
    true
  end
  
  def log_errors
    logger.debug "Error: #{self.errors.inspect}"
  end
  
end
