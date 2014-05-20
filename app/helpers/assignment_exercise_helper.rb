# Copyright 2011-2014 Rice University. Licensed under the Affero General Public
# License version 3 or later.  See the COPYRIGHT file for details.

 module AssignmentExerciseHelper

  def assignment_exercise_index(assignment_exercise)
    assignment_exercise.number - 1
  end

  def prev_assignment_exercise(assignment_exercise)
    index =  assignment_exercise_index(assignment_exercise)
    if index > 0
      assignment_exercise.assignment.assignment_exercises[index-1]
    end
  end

  def next_assignment_exercise(assignment_exercise)
    index =  assignment_exercise_index(assignment_exercise)
    if index < assignment_exercise.assignment.assignment_exercises.count - 1
      assignment_exercise.assignment.assignment_exercises[index+1]
    end
  end

end
