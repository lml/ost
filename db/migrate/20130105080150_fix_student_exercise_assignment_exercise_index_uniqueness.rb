class FixStudentExerciseAssignmentExerciseIndexUniqueness < ActiveRecord::Migration
  def up
    add_index     :student_exercises, [:assignment_exercise_id, :student_assignment_id], :unique => true, :name => "index_student_exercises_on_assignment_exercise_scoped"
  end

  def down
    remove_index  :student_exercises, :name => "index_student_exercises_on_assignment_exercise_scoped"
  end
end
