class StudentExercise < ActiveRecord::Base
  attr_accessible :assignment_exercise_id, :automated_credit, :content_cache, :free_response, :free_response_confidence, :free_response_submitted_at, :manual_credit, :selected_answer, :selected_answer_submitted_at, :student_assignment_id, :was_submitted_late
end
