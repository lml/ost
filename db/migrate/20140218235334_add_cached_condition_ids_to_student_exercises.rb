class AddCachedConditionIdsToStudentExercises < ActiveRecord::Migration
  def change
    add_column :student_exercises, :feedback_condition_id, :integer
    add_column :student_exercises, :presentation_condition_id, :integer

    add_index :student_exercises, :feedback_condition_id
    add_index :student_exercises, :presentation_condition_id
  end
end
