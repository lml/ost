class RemoveExerciseTagsFromAssignmentPlan < ActiveRecord::Migration
  def change
    remove_column :assignment_plans, :exercise_tags
  end
end
