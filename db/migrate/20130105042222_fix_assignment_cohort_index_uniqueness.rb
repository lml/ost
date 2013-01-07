class FixAssignmentCohortIndexUniqueness < ActiveRecord::Migration
  def up
    add_index     :assignments, [:cohort_id, :assignment_plan_id], :unique => true, :name => "index_assignments_on_cohort_id_scoped"
  end

  def down
    remove_index  :assignments, :name => "index_assignments_on_cohort_id_scoped"
  end
end
