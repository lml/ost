class TerpController < ApplicationController

  skip_before_filter :authenticate_user!
  fine_print_skip_signatures :general_terms_of_use, :privacy_policy # TODO don't skip always
  before_filter :terp_authenticate_user!, except: [:preview, :about, :sign_in, :sign_up]

  before_filter :get_student_assignment, only: [:quiz_start]
  before_filter :get_student_exercise, only: [:question_free_response, :question_feedback, 
                                              :question_answer_selection, :question_update]

  # interceptor :terp_authenticate_user, except: [:preview, :about, :sign_up]

  # need an authenticate before filter that redirects here not the normal place

  # acts_as_interceptor

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

  def logout
    sign_out
    redirect_to terp_quiz_start_path(params[:terp_id])
  end

  def consent; end

  def quiz_start
  end

  def instructions
  end

  def question_free_response
    raise SecurityTransgression unless present_user.can_read?(@student_exercise)
    @include_mathjax = true
  end

  def question_update
    raise SecurityTransgression unless present_user.can_update?(@student_exercise)
   
    @student_exercise.lock_response_text_on_next_save = true if params[:save_and_lock]
   
    respond_to do |format|
      if @student_exercise.update_attributes(params[:student_exercise])
        flash[:notice] = "Response saved."
        if @student_exercise.selected_answer_submitted? && 
           @student_exercise.is_feedback_available? &&
           @student_exercise.can_automatically_show_feedback?
          format.html { redirect_to(terp_question_feedback_path(@student_exercise)) }
        else
          format.html { redirect_to(terp_question_answer_selection_path(@student_exercise)) }
        end
      else
        @include_mathjax = true
        format.html { render :action => "question_free_response" }  
      end
    end
  end

  def question_answer_selection
    raise SecurityTransgression unless present_user.can_read?(@student_exercise)
    @include_mathjax = true
  end

  def question_feedback
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

protected

  def redirect_to_quiz_start
    redirect_to terp_quiz_start_path(terp_id: params[:terp_id])
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
      raise IllegalState, "you somehow have too many assignments"
    elsif @student_assignment.count == 0
      raise NotYetImplemented, "need to figure out if this student needs to register for a class, depends on if student has a class, if the embed code exists, etc"
    end

    @student_assignment = @student_assignment.first

  end

  def get_student_exercise
    @student_exercise = StudentExercise.find(params[:student_exercise_id])
  end



end
