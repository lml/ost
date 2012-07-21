
class StudentAssignmentsController < ApplicationController
  # GET /student_assignments
  # GET /student_assignments.json
  def index
    @student_assignments = StudentAssignment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @student_assignments }
    end
  end

  # GET /student_assignments/1
  # GET /student_assignments/1.json
  def show
    @student_assignment = StudentAssignment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @student_assignment }
    end
  end

  # GET /student_assignments/new
  # GET /student_assignments/new.json
  def new
    @student_assignment = StudentAssignment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @student_assignment }
    end
  end

  # GET /student_assignments/1/edit
  def edit
    @student_assignment = StudentAssignment.find(params[:id])
  end

  # POST /student_assignments
  # POST /student_assignments.json
  def create
    @student_assignment = StudentAssignment.new(params[:student_assignment])

    respond_to do |format|
      if @student_assignment.save
        format.html { redirect_to @student_assignment, notice: 'Student assignment was successfully created.' }
        format.json { render json: @student_assignment, status: :created, location: @student_assignment }
      else
        format.html { render action: "new" }
        format.json { render json: @student_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /student_assignments/1
  # PUT /student_assignments/1.json
  def update
    @student_assignment = StudentAssignment.find(params[:id])

    respond_to do |format|
      if @student_assignment.update_attributes(params[:student_assignment])
        format.html { redirect_to @student_assignment, notice: 'Student assignment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @student_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /student_assignments/1
  # DELETE /student_assignments/1.json
  def destroy
    @student_assignment = StudentAssignment.find(params[:id])
    @student_assignment.destroy

    respond_to do |format|
      format.html { redirect_to student_assignments_url }
      format.json { head :no_content }
    end
  end
end
