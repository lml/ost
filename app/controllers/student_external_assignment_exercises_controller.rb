class StudentExternalAssignmentExercisesController < ApplicationController

  can_edit_on_the_spot :check_access

  def show
    @seae = StudentExternalAssignmentExercise.find(params[:id])
    raise SecurityTransgression unless present_user.can_read?(@seae.external_assignment_exercise.external_assignment)

    respond_to do |format|
      format.html { render "show", layout: false }
    end
  end

protected

  def check_access(student_external_assignment_exercise, field_name)
    present_user.can_update?(student_external_assignment_exercise.external_assignment_exercise)
  end

end
