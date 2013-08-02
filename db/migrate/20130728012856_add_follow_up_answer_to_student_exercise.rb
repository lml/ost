class AddFollowUpAnswerToStudentExercise < ActiveRecord::Migration
  def change
    add_column :student_exercises, :follow_up_answer, :string
  end
end
