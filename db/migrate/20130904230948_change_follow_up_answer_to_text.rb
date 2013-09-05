class ChangeFollowUpAnswerToText < ActiveRecord::Migration
  def up
    rename_index  :student_exercises, "index_student_exercises_on_assignment_exercise_scoped", "index_ses_on_aes_scoped"
    change_column :student_exercises, :follow_up_answer, :text
  end

  def down
    change_column :student_exercises, :follow_up_answer, :string
    rename_index  :student_exercises, "index_ses_on_aes_scoped", "index_student_exercises_on_assignment_exercise_scoped"
  end
end
