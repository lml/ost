class ExternalAssignmentExercisesController < ApplicationController
  can_edit_on_the_spot

  before_filter :set_members, only: [ :show, :destroy ]

  def show
    raise SecurityTransgression unless present_user.can_read?(@external_assignment_exercise)
  end

  def destroy
    raise SecurityTransgression unless present_user.can_destroy?(@external_assignment_exercise)
    @external_assignment_exercise.destroy
  end

  def sort
    super('external_assignment_exercise', ExternalAssignmentExercise,
          @external_assignment, :external_assignment)
  end

protected

  def set_members
    @external_assignment_exercise = get_external_assignment_exercise
    @external_assignment          = get_external_assignment(@external_assignment_exercise)
  end

  def get_external_assignment_exercise
    if params[:id]
      ExternalAssignmentExercise.find(params[:id])
    else
      ExternalAssignmentExercise.new(params[:external_assignment_exercise])
    end
  end

  def get_external_assignment(external_assignment_exercise)
    if params[:external_assignment_id]
      ExternalAssignment.find(params[:external_assignment_id])
    elsif external_assignment_exercise
      external_assignment_exercise.external_assignment
    end
  end

end
