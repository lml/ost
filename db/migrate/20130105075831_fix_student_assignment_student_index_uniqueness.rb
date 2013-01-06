class FixStudentAssignmentStudentIndexUniqueness < ActiveRecord::Migration
  def up
    add_index     :student_assignments, [:student_id, :assignment_id], :unique => true, :name => "index_student_assignments_on_student_id_scoped"
  end

  def down
    remove_index  :student_assignments, :name => "index_student_assignments_on_student_id_scoped"
  end
end
