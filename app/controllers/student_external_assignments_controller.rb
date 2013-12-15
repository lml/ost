class StudentExternalAssignmentsController < ApplicationController

  can_edit_on_the_spot

  def show
    @sea = StudentExternalAssignment.find(params[:id])
    raise SecurityTransgression unless present_user.can_read?(@sea.external_assignment)

    respond_to do |format|
      format.html { render "show", layout: false }
    end
  end

  def update_grade
    logger.debug "SEA Controller #update: #{params}"

    @sea = StudentExternalAssignment.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@sea.external_assignment)

    respond_to do |format|
      @sea.grade = params[:value]
      @sea.save!

      format.json { respond_with @sea }
    end
  end
end
