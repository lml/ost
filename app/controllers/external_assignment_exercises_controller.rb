class ExternalAssignmentExercisesController < ApplicationController
  before_filter :set_members, except: [ :sort ]

  def new
    raise SecurityTransgression unless present_user.can_create?(@external_assignment_exercise)
  end

  def edit
    raise SecurityTransgression unless present_user.can_update?(@external_assignment_exercise)
  end

  def create
    @external_assignment_exercise.external_assignment   = @external_assignment
    @external_assignment_exercise.name                ||= "Unnamed Exercise"

    raise SecurityTransgression unless present_user.can_create?(@external_assignment_exercise)

    respond_to do |format|
      if @external_assignment_exercise.save
        format.html { redirect_to edit_external_assignment_exercise_path(@external_assignment_exercise), notice: 'External Assignment Exercise was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    raise SecurityTransgression unless present_user.can_update?(@external_assignment_exercise)

    respond_to do |format|
      if @external_assignment_exercise.update_attributes(params[:external_assignment_exercise])
        format.html { redirect_to edit_external_assignment_path(@external_assignment_exercise.external_assignment), notice: 'External Assignment Exercise was successfully updated.' }
      else
        format.html { render action: "edit" }
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
