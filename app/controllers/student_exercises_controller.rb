# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.


class StudentExercisesController < ApplicationController

  before_filter :enable_timeout, :only => [:show, :feedback]
  before_filter :enable_clock, :only => [:show, :feedback]

  def show
    @student_exercise = StudentExercise.find(params[:id])
    raise SecurityTransgression unless present_user.can_read?(@student_exercise)
    @include_mathjax = true    
  end

  def update
    @student_exercise = StudentExercise.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@student_exercise)
   
    @student_exercise.lock_response_text_on_next_save = true if params[:save_and_lock]
   
    respond_to do |format|
      if @student_exercise.update_attributes(params[:student_exercise])
        flash[:notice] = "Response saved."
        if @student_exercise.selected_answer_submitted? && 
           @student_exercise.is_feedback_available? &&
           @student_exercise.can_automatically_show_feedback?
          format.html { redirect_to(student_exercise_feedback_path(@student_exercise)) }
        else
          format.html { redirect_to(@student_exercise) }
        end
      else
        @include_mathjax = true
        format.html { render :action => "show" }  
      end
    end
  end
  
  def make_correct
    @student_exercise = StudentExercise.find(params[:student_exercise_id])
    raise SecurityTransgression unless @student_exercise.can_be_changed_by?(present_user)
    @student_exercise.force_to_be_correct!
    respond_to do |format|
      format.js { render :text => 'alert("Refresh page to see that the problem is corrected.")'}
    end
  end
  
  def feedback
    @student_exercise = StudentExercise.find(params[:student_exercise_id])
    raise SecurityTransgression unless present_user.can_read?(@student_exercise) && 
                                       @student_exercise.is_feedback_available?
    
    # If the person going to look at the feedback is the student whose exercise this is,
    # notify their learning condition that they've viewed it.                                   
    @student_exercise.note_feedback_viewed! if @student_exercise.belongs_to_student_user?(present_user)
    
    @include_mathjax = true
  end
  
  def score_detail
    @student_exercise = StudentExercise.find(params[:student_exercise_id]) 
    raise SecurityTransgression unless @student_exercise.can_be_changed_by?(present_user)
  end

end
