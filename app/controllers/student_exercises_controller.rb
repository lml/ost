
class StudentExercisesController < ApplicationController
  # GET /student_exercises
  # GET /student_exercises.json
  def index
    @student_exercises = StudentExercise.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @student_exercises }
    end
  end

  # GET /student_exercises/1
  # GET /student_exercises/1.json
  def show
    @student_exercise = StudentExercise.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @student_exercise }
    end
  end

  # GET /student_exercises/new
  # GET /student_exercises/new.json
  def new
    @student_exercise = StudentExercise.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @student_exercise }
    end
  end

  # GET /student_exercises/1/edit
  def edit
    @student_exercise = StudentExercise.find(params[:id])
  end

  # POST /student_exercises
  # POST /student_exercises.json
  def create
    @student_exercise = StudentExercise.new(params[:student_exercise])

    respond_to do |format|
      if @student_exercise.save
        format.html { redirect_to @student_exercise, notice: 'Student exercise was successfully created.' }
        format.json { render json: @student_exercise, status: :created, location: @student_exercise }
      else
        format.html { render action: "new" }
        format.json { render json: @student_exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /student_exercises/1
  # PUT /student_exercises/1.json
  def update
    @student_exercise = StudentExercise.find(params[:id])

    respond_to do |format|
      if @student_exercise.update_attributes(params[:student_exercise])
        format.html { redirect_to @student_exercise, notice: 'Student exercise was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @student_exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /student_exercises/1
  # DELETE /student_exercises/1.json
  def destroy
    @student_exercise = StudentExercise.find(params[:id])
    @student_exercise.destroy

    respond_to do |format|
      format.html { redirect_to student_exercises_url }
      format.json { head :no_content }
    end
  end
end
