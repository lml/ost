
class TopicExercisesController < ApplicationController
  # GET /topic_exercises
  # GET /topic_exercises.json
  def index
    @topic_exercises = TopicExercise.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @topic_exercises }
    end
  end

  # GET /topic_exercises/1
  # GET /topic_exercises/1.json
  def show
    @topic_exercise = TopicExercise.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @topic_exercise }
    end
  end

  # GET /topic_exercises/new
  # GET /topic_exercises/new.json
  def new
    @topic_exercise = TopicExercise.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @topic_exercise }
    end
  end

  # GET /topic_exercises/1/edit
  def edit
    @topic_exercise = TopicExercise.find(params[:id])
  end

  # POST /topic_exercises
  # POST /topic_exercises.json
  def create
    @topic_exercise = TopicExercise.new(params[:topic_exercise])

    respond_to do |format|
      if @topic_exercise.save
        format.html { redirect_to @topic_exercise, notice: 'Topic exercise was successfully created.' }
        format.json { render json: @topic_exercise, status: :created, location: @topic_exercise }
      else
        format.html { render action: "new" }
        format.json { render json: @topic_exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /topic_exercises/1
  # PUT /topic_exercises/1.json
  def update
    @topic_exercise = TopicExercise.find(params[:id])

    respond_to do |format|
      if @topic_exercise.update_attributes(params[:topic_exercise])
        format.html { redirect_to @topic_exercise, notice: 'Topic exercise was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @topic_exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topic_exercises/1
  # DELETE /topic_exercises/1.json
  def destroy
    @topic_exercise = TopicExercise.find(params[:id])
    @topic_exercise.destroy

    respond_to do |format|
      format.html { redirect_to topic_exercises_url }
      format.json { head :no_content }
    end
  end
end
