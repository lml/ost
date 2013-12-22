class StudentExternalAssignmentExercisesController < ApplicationController

  can_edit_on_the_spot :check_access

protected

  def check_access(student_external_assignment_exercise, field_name)
    present_user.can_update?(student_external_assignment_exercise.external_assignment_exercise)
  end

end
