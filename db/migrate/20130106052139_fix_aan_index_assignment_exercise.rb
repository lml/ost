class FixAanIndexAssignmentExercise < ActiveRecord::Migration
  def up
    add_index     :assignment_exercises, [:number, :assignment_id], :unique => true, :name => "index_assignment_exercises_on_number_scoped"
  end

  def down
    remove_index  :assignment_exercises, :name => "index_assignment_exercises_on_number_scoped"
  end
end
