
class AssignmentExercisesController < ApplicationController
  # GET /assignment_exercises
  # GET /assignment_exercises.json
  def index
    @assignment_exercises = AssignmentExercise.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @assignment_exercises }
    end
  end

  # GET /assignment_exercises/1
  # GET /assignment_exercises/1.json
  def show
    @assignment_exercise = AssignmentExercise.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @assignment_exercise }
    end
  end

  # GET /assignment_exercises/new
  # GET /assignment_exercises/new.json
  def new
    @assignment_exercise = AssignmentExercise.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @assignment_exercise }
    end
  end

  # GET /assignment_exercises/1/edit
  def edit
    @assignment_exercise = AssignmentExercise.find(params[:id])
  end

  # POST /assignment_exercises
  # POST /assignment_exercises.json
  def create
    @assignment_exercise = AssignmentExercise.new(params[:assignment_exercise])

    respond_to do |format|
      if @assignment_exercise.save
        format.html { redirect_to @assignment_exercise, notice: 'Assignment exercise was successfully created.' }
        format.json { render json: @assignment_exercise, status: :created, location: @assignment_exercise }
      else
        format.html { render action: "new" }
        format.json { render json: @assignment_exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /assignment_exercises/1
  # PUT /assignment_exercises/1.json
  def update
    @assignment_exercise = AssignmentExercise.find(params[:id])

    respond_to do |format|
      if @assignment_exercise.update_attributes(params[:assignment_exercise])
        format.html { redirect_to @assignment_exercise, notice: 'Assignment exercise was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @assignment_exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assignment_exercises/1
  # DELETE /assignment_exercises/1.json
  def destroy
    @assignment_exercise = AssignmentExercise.find(params[:id])
    @assignment_exercise.destroy

    respond_to do |format|
      format.html { redirect_to assignment_exercises_url }
      format.json { head :no_content }
    end
  end
end
