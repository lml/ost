class AddCohortIdToAssignmentPlan < ActiveRecord::Migration
  def change
    add_column :assignment_plans, :cohort_id, :integer
    add_index :assignment_plans, :cohort_id
  end
end
