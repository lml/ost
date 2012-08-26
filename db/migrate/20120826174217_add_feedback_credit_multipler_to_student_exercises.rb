class AddFeedbackCreditMultiplerToStudentExercises < ActiveRecord::Migration
  def change
    add_column :student_exercises, :feedback_credit_multiplier, :float, :default => 1
  end
end
