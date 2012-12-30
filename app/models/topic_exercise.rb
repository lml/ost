# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class TopicExercise < ActiveRecord::Base
  include BelongsToExercise
  belongs_to :concept
  belongs_to :topic
  has_many :assignment_exercises, :dependent => :destroy
  
  before_destroy :destroyable?
  
  validates :topic_id, :presence => true
  # validates :exercise_id, :presence => true, :uniqueness => {:scope => :topic_id}
  validate :changing_topic_not_assigned, :on => :update  
  validate :url_unchanged_when_assigned, :on => :update
  validate :order_unchanged_when_assigned, :on => :update
        
  acts_as_numberable :container => :topic
  
  attr_accessible :exercise_id, :exercise, :topic_id, :topic, :name, :reserved_for_tests
  
  scope :for_tests, where{reserved_for_tests == true}
  
  def destroyable?
    return true if WebsiteConfiguration.get_value(:sudo_enabled)
    errors.add(:base, "This exercise cannot be deleted because it has already been assigned.") if assigned?
    errors.none?
  end
  
  def assigned?
    assignment_exercises(true).any?
    # The following works but is no longer the way we do it -- keeping in case we need an example
    # StudentExercise.joins{assignment_exercise.topic_exercise}.where{assignment_exercise.topic_exercise_id == id}.any?
  end
  
  def assigned_in_cohort?(cohort)
    assignment_exercises.joins{assignment}.where{assignment.cohort_id == cohort.id}.any?
  end
  
  def changing_topic_not_assigned    
    return true if !topic_id_changed?
    old_topic = Topic.find(topic_id_was)
    new_topic = topic
    return true if old_topic.not_assigned? && new_topic.not_assigned?
    self.errors.add(:base,"This exercise cannot change topics because at least " +
                          "one of the source or destination topics has already " +
                          "been assigned.")
    false
  end
  
  def url_unchanged_when_assigned
    return true if !assigned? || (!exercise_id_changed? && !exercise.new_record?)
    self.errors.add(:base, "The exercise content cannot be changed because this " + 
                           "exercise's topic has already been assigned")
    false
  end
  
  def order_unchanged_when_assigned
    return true if topic.not_assigned? || !number_changed?
    self.errors.add(:number, "cannot be changed once assigned")
    false
  end
  
  def update_url!(url)
    url = 'http://' + url if !url[/^https?:\/\//]
    
    return if !exercise.nil? && exercise.url == url
    self.exercise_id_will_change!
    self.exercise = Exercise.new_or_existing(url)
    self.save!
  end
  
  def update_concept!(concept_id)
    self.concept_id = concept_id
    self.save!
  end
  
  def clear_cached_exercise_content!
    exercise.clear_content_cache!
  end
  
  def display_name
    name.blank? ? exercise.quadbase_id : name
  end
  
  #############################################################################
  # Access control methods
  #############################################################################

  def can_be_read_by?(user)
    topic.can_be_read_by?(user)
  end
    
  def can_be_created_by?(user)
    topic.can_be_updated_by?(user)
  end
  
  def can_be_updated_by?(user)
    topic.can_be_updated_by?(user)
  end
  
  def can_be_destroyed_by?(user)
    topic.can_be_updated_by?(user)
  end
  
  def can_be_sorted_by?(user)
    can_be_updated_by?(user)
  end
  
end
