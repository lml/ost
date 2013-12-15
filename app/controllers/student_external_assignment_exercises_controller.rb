class StudentExternalAssignmentExercisesController < ApplicationController

  can_edit_on_the_spot

  def show
    @seae = StudentExternalAssignmentExercise.find(params[:id])
    raise SecurityTransgression unless present_user.can_read?(@seae.external_assignment_exercise.external_assignment)

    respond_to do |format|
      format.html { render "show", layout: false }
    end
  end

  def update_grade
    logger.debug "SEAE Controller #update: #{params}"

    @seae = StudentExternalAssignmentExercise.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@seae.external_assignment_exercise.external_assignment)

    respond_to do |format|
      @seae.grade = params[:value]
      @seae.save!

      format.json { respond_with @seae }
    end
  end
end
