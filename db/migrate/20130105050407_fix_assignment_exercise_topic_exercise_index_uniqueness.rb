class FixAssignmentExerciseTopicExerciseIndexUniqueness < ActiveRecord::Migration
  def up
    add_index     :assignment_exercises, [:topic_exercise_id, :assignment_id], :unique => true, :name => "index_assignment_exercises_on_topic_exercise_id_scoped"
  end

  def down
    remove_index  :assignment_exercises, :name => "index_assignment_exercises_on_topic_exercise_id_scoped"
  end
end
