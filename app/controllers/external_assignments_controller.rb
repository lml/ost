class ExternalAssignmentsController < ApplicationController

  before_filter :get_klass, :only => [:index, :new, :create]

  def index
    raise SecurityTransgression unless present_user.can_read_children?(@klass, :external_assignments)
    @external_assignments = @klass.external_assignments
  end

  def show
    @external_assignment = ExternalAssignment.find(params[:id])
    raise SecurityTransgression unless present_user.can_read?(@external_assignment)

    @external_assignment.add_missing_components
  end

  def new
    @external_assignment = ExternalAssignment.new(klass: @klass)
    raise SecurityTransgression unless present_user.can_create?(@external_assignment)
  end

  def edit
    @external_assignment = ExternalAssignment.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@external_assignment)

    @external_assignment.add_missing_components
  end

  def create
    @external_assignment = ExternalAssignment.new(params[:external_assignment])
    @external_assignment.klass   = @klass
    @external_assignment.name  ||= "Unnamed Assignment"

    raise SecurityTransgression unless present_user.can_create?(@external_assignment)

    respond_to do |format|
      if @external_assignment.save
        format.html { redirect_to edit_external_assignment_path(@external_assignment), notice: 'External Assignment was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @external_assignment = ExternalAssignment.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@external_assignment)

    respond_to do |format|
      if @external_assignment.update_attributes(params[:external_assignment])
        format.html { redirect_to klass_external_assignments_path(@external_assignment.klass), notice: 'External Assignment was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @external_assignment = ExternalAssignment.find(params[:id])
    raise SecurityTransgression unless present_user.can_destroy?(@external_assignment)
    @external_assignment.destroy
  end

  def sort
    super('external_assignment', ExternalAssignment,
          @klass, :klass)
  end

  def show_table
    @external_assignment = ExternalAssignment.find(params[:id])
    raise SecurityTransgression unless present_user.can_read?(@external_assignment)

    @external_assignment.add_missing_components
  end

protected

  def get_klass
    @klass = Klass.find(params[:klass_id])
  end

end
