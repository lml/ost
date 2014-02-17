# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

module StudentExercisesHelper
  def confidence_labels
    ["Definitely-Wrong", "Probably-Wrong", "Maybe Wrong,-Maybe Right", "Probably-Right", "Definitely-Right"]
  end

  def student_exercise_index(student_exercise)
    student_exercise.assignment_exercise.number - 1
  end

  def prev_student_exercise(student_exercise)
    index = student_exercise_index(student_exercise)
    if index > 0
      student_exercise.student_assignment.student_exercises[index-1]
    end
  end

  def next_student_exercise(student_exercise)
    index = student_exercise_index(student_exercise)
    if index < student_exercise.student_assignment.student_exercises.count - 1
      student_exercise.student_assignment.student_exercises[index+1]
    end
  end

  def available_student_exercise_feedback_path(student_exercise)
    return nil if student_exercise.nil?
    student_exercise.is_feedback_available? ? student_exercise_feedback_path(student_exercise) : nil
  end

  # def prev_available_student_exercise_feedback_path(student_exercise)
  #   index = student_exercise_index(student_exercise)
  #   if index > 0
  #     ses = student_exercise.student_assignment.student_exercises[0..index-1]
  #     se = ses.reverse.detect{|se| se.is_feedback_available?}
  #     available_student_exercise_feedback_path(se)
  #   end
  # end

  # def next_available_student_exercise_feedback_path(student_exercise)
  #   index = student_exercise_index(student_exercise)
  #   ses = Array(student_exercise.student_assignment.student_exercises[index+1..-1])
  #   se = ses.detect{|se| se.is_feedback_available?}
  #   available_student_exercise_feedback_path(se)
  # end
end
