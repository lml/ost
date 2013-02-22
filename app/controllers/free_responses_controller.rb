class FreeResponsesController < ApplicationController

  before_filter :get_student_exercise, :only => [:new, :create, :sort, :email_instructions, :refresh]
  before_filter :make_free_response, :only => [:new, :create]
  before_filter :grab_view_helper_variables, :only => [:create, :update]

  def new
  end

  def edit
    @free_response = FreeResponse.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@free_response)
  end

  def create
    raise SecurityTransgression unless present_user.can_create?(@free_response)
    @free_response.save
    render :template => 'free_responses/create_or_update'
  end

  def update
    @free_response = FreeResponse.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@free_response)
    @free_response.update_attributes(params[:free_response])
    render :template => 'free_responses/create_or_update'
  end

  def destroy
    @free_response = FreeResponse.find(params[:id])
    raise SecurityTransgression unless present_user.can_destroy?(@free_response)
    @free_response.destroy
  end

  def sort
    super('free_response', FreeResponse, @student_exercise, :student_exercise)
  end

  def email_instructions
    @mail_hook = @student_exercise.get_mail_hook
    @mail_hook.extend_expiration!
  end

  def refresh
    raise SecurityTransgression unless present_user.can_read?(@student_exercise)
    @new_free_responses = FreeResponse.where{student_exercise_id == my{@student_exercise}.id}.
                                       where{id << my{params[:idsOnPage]}}.all
  end

protected

  def get_student_exercise
    @student_exercise = StudentExercise.find(params[:student_exercise_id])
  end

  def make_free_response
    type = params[:type]
    @free_response = 
      case type
      when 'TextFreeResponse' 
        TextFreeResponse.new(params[:free_response])
      when 'FileFreeResponse'
        FileFreeResponse.new(params[:free_response])
      when 'DrawingFreeResponse'
        DrawingFreeResponse.new(params[:free_response])
      else
        raise AbstractController::ActionNotFound
      end
    @free_response.student_exercise = @student_exercise
  end

  def grab_view_helper_variables
    @free_response_form_id = params[:free_response_form_id]
  end

end
