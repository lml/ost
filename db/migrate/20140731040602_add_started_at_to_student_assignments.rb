class AddStartedAtToStudentAssignments < ActiveRecord::Migration
  def change
    add_column :student_assignments, :started_at, :datetime
  end
end
