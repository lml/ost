class StudentExternalAssignmentsController < ApplicationController

  can_edit_on_the_spot :check_access

  def show
    @sea = StudentExternalAssignment.find(params[:id])
    raise SecurityTransgression unless present_user.can_read?(@sea.external_assignment)

    respond_to do |format|
      format.html { render "show", layout: false }
    end
  end

protected

  def check_access(student_external_assignment, field_name)
    present_user.can_update?(student_external_assignment.external_assignment)
  end

end
