class FixAssignmentCoworkerStudentIndexUniqueness < ActiveRecord::Migration
  def up
    add_index    :assignment_coworkers, [:student_id, :student_assignment_id], :unique => true, :name => "index_assignment_coworkers_on_student_id_scoped"
  end

  def down
    remove_index :assignment_coworkers, :name => "index_assignment_coworkers_on_student_id_scoped"
  end
end
