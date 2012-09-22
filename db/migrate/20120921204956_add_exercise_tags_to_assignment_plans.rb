class AddExerciseTagsToAssignmentPlans < ActiveRecord::Migration
  def change
    add_column :assignment_plans, :exercise_tags, :string
  end
end
