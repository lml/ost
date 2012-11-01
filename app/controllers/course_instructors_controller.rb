# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.


class CourseInstructorsController < ApplicationController

  before_filter :get_course, :only => [:create, :new, :search]

  def new
    @course_instructor = CourseInstructor.new(:course => @course)
    raise SecurityTransgression unless present_user.can_create?(@course_instructor)
    
    @action_dialog_title = "Add an instructor"
    @action_search_path = search_course_course_instructors_path

    respond_to do |format|
      format.js { render :template => 'users/action_new' }
    end
  end
  
  def search
    @selected_type = params[:selected_type]
    @text_query = params[:text_query]
    @users = User.search(@selected_type, @text_query)

    # Don't show existing instructors
    existing_instructor_ids = @course.course_instructors.collect{|ci| ci.user.id}
    @users.reject! {|user| existing_instructor_ids.any?{|eui| eui == user.id}}
    
    @action_partial = 'course_instructors/create_course_instructor_form'
    
    respond_to do |format|
      format.js { render :template => 'users/action_search' }
    end
  end

  def create
    @course_instructor = CourseInstructor.new(params[:course_instructor])
    @course_instructor.course = @course
    raise SecurityTransgression unless present_user.can_create?(@course_instructor)

    respond_to do |format|
      if @course_instructor.save
        format.js
      else
        flash[:alert] = @course_instructor.errors.values.to_sentence
        format.js { render :template => 'shared/display_flash' }
      end
    end
  end

  def destroy
    @course_instructor = CourseInstructor.find(params[:id])
    @course_instructor.destroy

    raise SecurityTransgression unless present_user.can_destroy?(@course_instructor)

    respond_to do |format|
      format.html { redirect_to course_path(@course_instructor.course)}
    end
  end
  
protected

  def get_course
    @course = Course.find(params[:course_id])
  end

end
