class TerpController < ApplicationController

  skip_before_filter :authenticate_user!
  fine_print_skip_signatures :general_terms_of_use, :privacy_policy # TODO don't skip always
  before_filter :terp_authenticate_user!, except: [:preview, :about, :sign_in, :sign_up]

  before_filter :get_student_assignment, only: [:quiz_start]
  before_filter :get_student_exercise, only: [:solicit_free_response, :save_free_response,
                                              :solicit_answer_selection, :save_answer_selection,
                                              :present_feedback]

  layout :layout

  protect_beta

  alias_method :devise_sign_in, :sign_in

  def sign_in; end

  def sign_up
    if request.get?
      user_signed_in? ? redirect_to_quiz_start : render
    elsif request.post?
      handle_with(TerpSignUp,
                  user_state: self,
                  success: lambda { redirect_to_quiz_start },
                  failure: lambda { render 'terp/sign_up' })
    else
      raise IllegalOperation
    end
  end

  def register # like sign up without user creation
    handle_with(TerpRegister,
                success: lambda { redirect_to_quiz_start },
                failure: lambda { render 'terp/missing_assignment' })
  end

  def logout
    sign_out
    redirect_to terp_quiz_start_path(params[:terp_id])
  end

  def consent; end

  def quiz_start
    raise SecurityTransgression unless present_user.can_read?(@student_assignment.assignment)
    # TODO advance user to farthest completed point
  end

  def instructions
  end

  def solicit_free_response
    raise SecurityTransgression unless present_user.can_read?(@student_exercise)

    if @student_exercise.selected_answer_submitted?
      redirect_to_feedback
    elsif @student_exercise.free_response_submitted?
      redirect_to_answer_selection
    end
    
    @include_mathjax = true
  end

  def save_free_response
    raise SecurityTransgression unless present_user.can_update?(@student_exercise)
   
    @student_exercise.lock_response_text_on_next_save = true if params[:save_and_lock]
    @student_exercise.free_responses << TextFreeResponse.new(content: params[:student_exercise].delete(:free_response))

    if @student_exercise.update_attributes(params[:student_exercise])
      flash[:notice] = "Response saved."
      redirect_to_answer_selection
    else
      @include_mathjax = true
      render :action => "solicit_free_response" 
    end
  end

  def solicit_answer_selection
    raise SecurityTransgression unless present_user.can_read?(@student_exercise)

    if !@student_exercise.free_response_submitted?
      redirect_to_free_response
    elsif @student_exercise.selected_answer_submitted?
      redirect_to_feedback
    end

    @include_mathjax = true
  end

  def save_answer_selection
    raise SecurityTransgression unless present_user.can_update?(@student_exercise)
   
    if @student_exercise.update_attributes(params[:student_exercise])
      flash[:notice] = "Response saved."
      redirect_to_feedback
    else
      @include_mathjax = true
      render :action => "solicit_answer_selection" 
    end
  end

  def present_feedback
    raise SecurityTransgression unless present_user.can_read?(@student_exercise) && 
                                       @student_exercise.is_feedback_available?
    
    # If the person going to look at the feedback is the student whose exercise this is,
    # notify their learning condition that they've viewed it.                                   
    @student_exercise.note_feedback_viewed! if @student_exercise.belongs_to_student_user?(present_user)
    
    @include_mathjax = true
  end

  def quiz_summary
  end

  def dashboard
  end

  def help
  end

  def my_account
  end

  def about
  end

  def preview
  end

  def account_help
  end

  def contact_us
  end

  def terms
  end

  def missing_assignment

  end

protected

  def redirect_to_quiz_start
    redirect_to terp_quiz_start_path(terp_id: params[:terp_id])
  end

  def redirect_to_feedback
    redirect_to(terp_present_feedback_path(terp_id: params[:terp_id], student_exercise_id: @student_exercise.id))
  end

  def redirect_to_answer_selection
    redirect_to(terp_solicit_answer_selection_path(terp_id: params[:terp_id], student_exercise_id: @student_exercise.id))
  end

  def redirect_to_free_response
    redirect_to(terp_solicit_free_response_path(terp_id: params[:terp_id], student_exercise_id: @student_exercise.id))
  end

  def layout
    action_name == "preview" ? false : "layouts/terp"
  end

  def terp_authenticate_user!
    if !user_signed_in?
      session[:user_return_to] = terp_quiz_start_path(params[:terp_id])
      redirect_to terp_sign_in_path(terp_id: params[:terp_id])
    end
  end

  def get_student_assignment
    @student_assignment = 
      StudentAssignment.joins{assignment.assignment_plan}
                       .joins{student}
                       .where{assignment.assignment_plan.embed_code == my{params[:terp_id]}}
                       .where{student.user_id == my{current_user.id}}.all

    if @student_assignment.count > 1
      redirect_to terp_too_many_assignments_path(terp_id: params[:terp_id])
    elsif @student_assignment.count == 0
      redirect_to terp_missing_assignment_path(terp_id: params[:terp_id])
    end

    @student_assignment = @student_assignment.first
  end

  def get_student_exercise
    @student_exercise = StudentExercise.find(params[:student_exercise_id])
  end



end
