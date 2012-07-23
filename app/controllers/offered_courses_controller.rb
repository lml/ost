require 'chronic'

class OfferedCoursesController < ApplicationController

  before_filter :get_course, :only => [:new, :create]
  before_filter :process_datetimes, :only => [:create, :update]

  def show
    @offered_course = OfferedCourse.find(params[:id])
    raise SecurityTransgression unless present_user.can_read?(@offered_course)
  end

  def new
    @offered_course = OfferedCourse.new
    @offered_course.course = @course
    raise SecurityTransgression unless present_user.can_create?(@offered_course)
  end

  def edit
    @offered_course = OfferedCourse.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@offered_course)
  end

  def create
    @offered_course = OfferedCourse.new(params[:offered_course])
    @offered_course.course = @course
    raise SecurityTransgression unless present_user.can_create?(@offered_course)    

    respond_to do |format|
      if @offered_course.save
        format.html { redirect_to @offered_course, notice: 'Offered course was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @offered_course = OfferedCourse.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@offered_course)

    respond_to do |format|
      if @offered_course.update_attributes(params[:offered_course])
        format.html { redirect_to @offered_course, notice: 'Offered course was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @offered_course = OfferedCourse.find(params[:id])
    raise SecurityTransgression unless present_user.can_destroy?(@offered_course)
    @offered_course.destroy
    redirect_to offered_courses_url
  end
  
protected

  def get_course
    @course = Course.find(params[:course_id])
  end
  
  def process_datetimes
    params[:offered_course][:start_date] = utc_from_time_and_zone(params[:offered_course][:start_date], 
                                                                  params[:offered_course][:time_zone])
    Rails.logger.debug(params[:offered_course][:start_date].inspect)
  end
end
