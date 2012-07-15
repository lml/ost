# This module should be included in all models that belong_to an exercise
module BelongsToExercise

  def self.included(base)
    base.class_eval do
      belongs_to :exercise
      after_update :exercise_may_have_changed
      after_destroy :exercise_may_be_orphaned
      accepts_nested_attributes_for :exercise 
      attr_protected :exercise_id
    end
  end
  
protected

  def exercise_may_be_orphaned
    exercise.destroy_if_orphan!
  end
  
  def exercise_may_have_changed
    Exercise.find(exercise_id_was).destroy_if_orphan! if exercise_id_changed?
  end
  
end