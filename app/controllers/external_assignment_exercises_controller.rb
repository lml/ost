class ExternalAssignmentExercisesController < ApplicationController

  can_edit_on_the_spot :check_access

  before_filter :set_members, only: [:create, :destroy]

  def create
    @external_assignment_exercise.external_assignment = @external_assignment
    @external_assignment_exercise.name                = "Ex #{@external_assignment.external_assignment_exercises.count + 1}"

    raise SecurityTransgression unless present_user.can_create?(@external_assignment_exercise)

    respond_to do |format|
      if @external_assignment_exercise.save
        format.html { redirect_to @external_assignment, notice: 'Exercise was successfully created.' }
      else
        format.html { redirect_to @external_assignment }
      end
    end
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

  def check_access(external_assignment_exercise, field_name)
    present_user.can_update?(external_assignment_exercise)
  end

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
