class FixAssignmentPlanNameIndexUniqueness < ActiveRecord::Migration
  def up
    add_index     :assignment_plans, [:name, :learning_plan_id], :unique => true, :name => "index_assignment_plan_on_name_scoped"
  end

  def down
    remove_index  :assignment_plans, :name => "index_assignment_plan_on_name_scoped"
  end
end
