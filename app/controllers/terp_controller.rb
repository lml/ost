class TerpController < ApplicationController

  skip_before_filter :authenticate_user!, only: [:preview]
  skip_before_filter :enable_miniprofiler_for_devs
  # need an authenticate before filter that redirects here not the normal place

  layout :layout

  protect_beta

  def sign_in_or_up
  end

  def consent
  end

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

protected

  def layout
    action_name == "preview" ? false : "layouts/terp"
  end
end
