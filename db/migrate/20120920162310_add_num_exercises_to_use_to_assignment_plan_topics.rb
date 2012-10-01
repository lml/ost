class AddNumExercisesToUseToAssignmentPlanTopics < ActiveRecord::Migration
  def change
    add_column :assignment_plan_topics, :num_exercises_to_use, :integer
  end
end
