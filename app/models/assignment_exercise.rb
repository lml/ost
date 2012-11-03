# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class AssignmentExercise < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :topic_exercise
  has_many :student_exercises
  
  acts_as_taggable
  
  # only checking for the assignment_id on update so that we can build up an
  # entire assignment and save it all together (assignment gets saved last, so
  # the assignment ID doesn't exist in time to be approved by this validation)
  validates :assignment_id, :presence => true, :on => :update
  validates :topic_exercise_id, :presence => true, :uniqueness => {:scope => :assignment_id}
  
  before_destroy :destroyable?
  
  acts_as_numberable :container => :assignment
  
  attr_accessible :assignment, :topic_exercise, :assignment_id
    
  def destroyable?
    errors.add(:base, "This assignment exercise cannot be deleted because it has already been distributed to students") \
      if student_exercises.any?
    errors.none?
  end
  
  # Expects comma-delimted tags, eg. "tag1, tag2"
  def add_tags(tags)
    tag_list.add(tags, :parse => true) if !tags.blank?
  end
  
  def has_tag?(tag)
    tag_list.include?(tag.downcase)
  end
end
