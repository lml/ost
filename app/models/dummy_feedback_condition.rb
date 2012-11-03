# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class DummyFeedbackCondition
  def is_feedback_available?(student_exercise)
    false
  end
  
  def notify_student_exercise_event(student_exercise, event); end
end