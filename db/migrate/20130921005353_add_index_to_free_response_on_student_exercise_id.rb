class AddIndexToFreeResponseOnStudentExerciseId < ActiveRecord::Migration
  def change
    add_index :free_responses, :student_exercise_id
  end
end
