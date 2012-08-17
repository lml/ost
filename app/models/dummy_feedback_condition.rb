class DummyFeedbackCondition
  def is_feedback_available?(student_exercise)
    student_exercise.selected_answer_submitted?
  end
end