class AddCompletedAtToStudentAssignments < ActiveRecord::Migration
  def change
    add_column :student_assignments, :completed_at, :datetime
  end
end
