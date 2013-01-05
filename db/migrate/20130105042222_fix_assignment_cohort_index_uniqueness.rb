class FixAssignmentCohortIndexUniqueness < ActiveRecord::Migration
  def up
    remove_index  :assignments, :cohort_id
    add_index     :assignments, [:cohort_id, :assignment_plan_id], :unique => true, :name => "index_assignments_on_cohort_id_scoped"
  end

  def down
    remove_index  :assignments, :name => "index_assignments_on_cohort_id_scoped"
    add_index     :assignments, :cohort_id
  end
end
