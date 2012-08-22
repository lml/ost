class DummyFeedbackCondition
  def is_feedback_available?(student_exercise)
    false
  end
  
  def notify_student_exercise_event(student_exercise, event); end
end