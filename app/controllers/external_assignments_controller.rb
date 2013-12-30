class ExternalAssignmentsController < ApplicationController

  can_edit_on_the_spot :check_access

  before_filter :get_klass, :only => [:index, :new, :create, :report]

  def index
    raise SecurityTransgression unless present_user.can_read_children?(@klass, :external_assignments)
    @external_assignments = @klass.external_assignments
  end

  def show
    @external_assignment = ExternalAssignment.find(params[:id])
    @klass = @external_assignment.klass

    raise SecurityTransgression unless present_user.can_read?(@external_assignment)

    @external_assignment.add_missing_components
  end

  def create
    @external_assignment = ExternalAssignment.new(params[:external_assignment])
    @external_assignment.klass   = @klass
    @external_assignment.name  ||= "External Assignment #{@klass.external_assignments.count + 1}"

    raise SecurityTransgression unless present_user.can_create?(@external_assignment)

    respond_to do |format|
      if @external_assignment.save
        format.html { redirect_to klass_external_assignments_path(@klass), notice: 'External Assignment was successfully created.' }
      else
        format.html { redirect_to klass_external_assignments_path(@klass) }
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

  def report
    raise SecurityTransgression unless present_user.can_read_children?(@klass, :external_assignments_report)

    @klass.external_assignments.each{|ea| ea.add_missing_components}

    respond_to do |format|
      format.xls { render 'report' }
    end
  end

protected

  def check_access(external_assignment, field_name)
    present_user.can_update?(external_assignment)
  end

  def get_klass
    @klass = Klass.find(params[:klass_id])
  end

end
