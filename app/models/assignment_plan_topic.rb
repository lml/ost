# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class AssignmentPlanTopic < ActiveRecord::Base
  belongs_to :assignment_plan
  belongs_to :topic
  
  validates :assignment_plan_id, :presence => true
  validates :topic_id, :presence => true, :uniqueness => {:scope => :assignment_plan_id}
  
  attr_accessible :assignment_plan, :topic_id, :num_exercises_to_use, :hide_resources
  
  before_destroy :destroyable?, prepend: true
  
  scope :resources_visible, where(:hide_resources => false)
    
    
  
  def destroyable?
    self.errors.add(:base, "This topic cannot be removed from its assignment because the assignment has been issued.") \
      if assignment_plan(true).assigned?
    self.errors.none?
  end
  
  def topic_exercises
    TopicExercise.joins{topic.assignment_plan_topics}.where{topic.assignment_plan_topics.id == my{id}}
  end
  
  #############################################################################
  # Access control methods
  #############################################################################
  
  def can_be_read_by?(user)
    assignment_plan.can_be_read_by?(user)
  end
    
  def can_be_created_by?(user)
    assignment_plan.can_be_updated_by?(user)
  end
  
  def can_be_updated_by?(user)
    assignment_plan.can_be_updated_by?(user)
  end
  
  def can_be_destroyed_by?(user)
    assignment_plan.can_be_updated_by?(user)
  end
  

end
