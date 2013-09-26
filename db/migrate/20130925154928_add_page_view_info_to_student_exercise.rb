class AddPageViewInfoToStudentExercise < ActiveRecord::Migration
  def change
    add_column :student_exercises, :exercise_first_viewed_at, :datetime
    add_column :student_exercises, :feedback_first_viewed_at, :datetime
    add_column :student_exercises, :feedback_views_count,     :integer
    add_column :student_exercises, :feedback_views_timestamp, :datetime, default: Chronic.parse('Jan 1 1980')
  end
end
