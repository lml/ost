
class StudentsController < ApplicationController

  before_filter :get_offered_course, :only => [:index]

  def index
  end

  def show
    @student = Student.find(params[:id])
  end

  def new
    @student = Student.new
  end

  def edit
    @student = Student.find(params[:id])
  end

  def create
    @student = Student.new(params[:student])

    respond_to do |format|
      if @student.save
        format.html { redirect_to @student, notice: 'Student was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @student = Student.find(params[:id])

    respond_to do |format|
      if @student.update_attributes(params[:student])
        format.html { redirect_to @student, notice: 'Student was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @student = Student.find(params[:id])
    @student.destroy
    redirect_to students_url
  end
  
protected

  def get_offered_course
    @offered_course = OfferedCourse.find(params[:offered_course_id])
  end
end
