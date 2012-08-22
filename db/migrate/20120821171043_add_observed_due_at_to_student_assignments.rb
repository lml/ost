class AddObservedDueAtToStudentAssignments < ActiveRecord::Migration
  def change
    add_column :student_assignments, :observed_due_at, :datetime
  end
end
