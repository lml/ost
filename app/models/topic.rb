# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class Topic < ActiveRecord::Base
  belongs_to :learning_plan
  has_many :topic_exercises, :dependent => :destroy, :order => :number, :include => :exercise
  has_many :assignment_plan_topics, :dependent => :destroy
  has_many :assignment_plans, :through => :assignment_plan_topics
  has_many :resources, :order => :number
  
  before_destroy :destroyable?, prepend: true
  
  validates :learning_plan_id, :presence => true
  validates :name, :presence => true, :uniqueness => {:scope => :learning_plan_id}
  
  acts_as_numberable :container => :learning_plan
  
  attr_accessible :name, :is_survey, :learning_plan_id
  
  before_validation :set_default_name, :on => :create

  scope :non_survey, lambda { where(:is_survey => false) }
  scope :survey, lambda { where(:is_survey => true) }
  
  def destroyable?
    self.errors.add(:base, "This topic cannot be destroyed because it is included in at least one assignment.") \
      if assignment_plan_topics(true).any?
    self.errors.none?
  end
  
  def not_assigned?
    !assigned?
  end
  
  def assigned?
    assignment_plans.any?{|ap| ap.assigned?}
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
    learning_plan.can_be_updated_by?(user)
  end

  def can_be_destroyed_by?(user)
    learning_plan.can_be_updated_by?(user)
  end
  
protected

  def set_default_name
    return unless name.blank?
    
    existing_topics = learning_plan.topics
    existing_names = existing_topics.collect{|t| t.name}
    topic_number = existing_topics.count + 1

    while (existing_names.include?(self.name = "New Topic #{topic_number}"))
      topic_number += 1
    end
  end
  
end
