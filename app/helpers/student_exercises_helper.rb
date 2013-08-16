# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

module StudentExercisesHelper
  def confidence_labels
    ["Definitely-Wrong", "Probably-Wrong", "Maybe Wrong,-Maybe Right", "Probably-Right", "Definitely-Right"]
  end

  def prev_student_exercise(student_exercise)
    index = student_exercise.assignment_exercise.number - 1
    if index > 0
      student_exercise.student_assignment.student_exercises[index-1]
    end
  end

  def next_student_exercise(student_exercise)
    index = student_exercise.assignment_exercise.number - 1
    if index < student_exercise.student_assignment.student_exercises.count - 1
      student_exercise.student_assignment.student_exercises[index+1]
    end
  end
end
