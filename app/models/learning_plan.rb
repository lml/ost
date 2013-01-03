# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class LearningPlan < ActiveRecord::Base
  belongs_to :klass
  has_many :topics, :dependent => :destroy, :order => :number
  has_many :assignment_plans, :dependent => :destroy, :order => :starts_at
  has_many :concepts, :dependent => :destroy, :order => :number
  
  validates :klass_id, :presence => true
  validates :name, :presence => true
  
  validates :test_exercise_tags,    :tag_list_format => true
  validates :nontest_exercise_tags, :tag_list_format => true

  before_destroy :destroyable?
  
  attr_accessible :description, :name,
                  :test_exercise_tags, :nontest_exercise_tags
  
  def destroyable?
    true # depends on children freaking out if they shouldn't be destroyed
  end
  
  def clear_cached_exercise_content!
    exercises = Exercise.joins{topic_exercises.topic.learning_plan}
                        .where{topic_exercises.topic.learning_plan.id == my{id}}
    exercises = Exercise.find(exercises.collect{|e| e.id})
    exercises.each{|e| e.clear_content_cache!}
  end
  
  
  #############################################################################
  # Access control methods
  #############################################################################
  
  def can_be_read_by?(user)
    klass.is_teaching_assistant?(user) || user.is_researcher? || user.is_administrator?
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
