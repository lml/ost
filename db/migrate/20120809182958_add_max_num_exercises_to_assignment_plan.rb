class AddMaxNumExercisesToAssignmentPlan < ActiveRecord::Migration
  def change
    add_column :assignment_plans, :max_num_exercises, :integer
  end
end
