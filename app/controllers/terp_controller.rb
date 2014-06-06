class TerpController < ApplicationController

  skip_before_filter :authenticate_user!
  fine_print_skip_signatures :general_terms_of_use, :privacy_policy # TODO don't skip always
  before_filter :terp_authenticate_user!, except: [:preview, :about, :sign_in, :sign_up]

  # interceptor :terp_authenticate_user, except: [:preview, :about, :sign_up]

  # need an authenticate before filter that redirects here not the normal place

  # acts_as_interceptor

  layout :layout

  protect_beta

  def sign_in; end

  def sign_up
    if request.get?
      render
    elsif request.post?
      handle_with(TerpSignUp,
                  success: lambda { redirect_to terp_quiz_start_path(terp_id: params[:terp_id]) },
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
  end

  def question_answer_selection
  end

  def question_feedback
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

  def layout
    action_name == "preview" ? false : "layouts/terp"
  end

  def terp_authenticate_user!
    if !user_signed_in?
      session[:user_return_to] = terp_quiz_start_path(params[:terp_id])
      redirect_to terp_sign_in_path(terp_id: params[:terp_id])
    end
  end

end
