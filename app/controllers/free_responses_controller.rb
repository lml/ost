class FreeResponsesController < ApplicationController

  before_filter :get_student_exercise

  def new
    @free_response = 
      case params[:type]
      when 'TextFreeResponse' 
        TextFreeResponse.new
      else
        raise AbstractController::ActionNotFound
      end
  end

  def edit
    @free_response = FreeResponse.find(params[:id])
  end

  def create
    @free_response = FreeResponse.new(params[:free_response])

    respond_to do |format|
      if @free_response.save
        format.html { redirect_to @free_response, notice: 'Free response was successfully created.' }
        format.json { render json: @free_response, status: :created, location: @free_response }
      else
        format.html { render action: "new" }
        format.json { render json: @free_response.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @free_response = FreeResponse.find(params[:id])

    respond_to do |format|
      if @free_response.update_attributes(params[:free_response])
        format.html { redirect_to @free_response, notice: 'Free response was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @free_response = FreeResponse.find(params[:id])
    @free_response.destroy
  end

protected

  def get_student_exercise
    @student_exercise = StudentExercise.find(params[:student_exercise_id])
  end

end
