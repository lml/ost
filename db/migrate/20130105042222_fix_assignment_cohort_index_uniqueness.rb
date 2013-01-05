class FixAssignmentCohortIndexUniqueness < ActiveRecord::Migration
  def up
    remove_index  :assignments, :cohort_id
    add_index     :assignments, [:cohort_id, :assignment_plan_id], :unique => true
  end

  def down
    remove_index  :assignments, [:cohort_id, :assignment_plan_id]
    add_index     :assignments, :cohort_id
  end
end
