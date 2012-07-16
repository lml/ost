
class OfferedCoursesController < ApplicationController
  # GET /offered_courses
  # GET /offered_courses.json
  def index
    @offered_courses = OfferedCourse.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @offered_courses }
    end
  end

  # GET /offered_courses/1
  # GET /offered_courses/1.json
  def show
    @offered_course = OfferedCourse.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @offered_course }
    end
  end

  # GET /offered_courses/new
  # GET /offered_courses/new.json
  def new
    @offered_course = OfferedCourse.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @offered_course }
    end
  end

  # GET /offered_courses/1/edit
  def edit
    @offered_course = OfferedCourse.find(params[:id])
  end

  # POST /offered_courses
  # POST /offered_courses.json
  def create
    @offered_course = OfferedCourse.new(params[:offered_course])

    respond_to do |format|
      if @offered_course.save
        format.html { redirect_to @offered_course, notice: 'Offered course was successfully created.' }
        format.json { render json: @offered_course, status: :created, location: @offered_course }
      else
        format.html { render action: "new" }
        format.json { render json: @offered_course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /offered_courses/1
  # PUT /offered_courses/1.json
  def update
    @offered_course = OfferedCourse.find(params[:id])

    respond_to do |format|
      if @offered_course.update_attributes(params[:offered_course])
        format.html { redirect_to @offered_course, notice: 'Offered course was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @offered_course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offered_courses/1
  # DELETE /offered_courses/1.json
  def destroy
    @offered_course = OfferedCourse.find(params[:id])
    @offered_course.destroy

    respond_to do |format|
      format.html { redirect_to offered_courses_url }
      format.json { head :no_content }
    end
  end
end
