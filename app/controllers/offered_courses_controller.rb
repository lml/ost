# class OfferedCoursesController < ApplicationController
# 
#   skip_before_filter :authenticate_user!, :only => [:index]
#   before_filter :get_course, :only => [:new, :create]
#   before_filter :set_time_zone, :only => [:create, :update]
# 
#   def index
#     @offered_courses = OfferedCourse.where{end_date > Time.zone.now}
#   end
# 
#   def show
#     @offered_course = OfferedCourse.find(params[:id])
#     raise SecurityTransgression unless present_user.can_read?(@offered_course)
#   end
# 
#   def new
#     @offered_course = OfferedCourse.new
#     @offered_course.course = @course
#     
#     redirect_to catalog_path, :alert => "A manager at #{@course.organization.name} needs to give you permission to teach this class." \
#       unless present_user.can_create?(@offered_course)
#   end
#   
#   def help; end
# 
#   def edit
#     @offered_course = OfferedCourse.find(params[:id])
#     raise SecurityTransgression unless present_user.can_update?(@offered_course)
#   end
# 
#   def create
#     @offered_course = OfferedCourse.new(params[:offered_course])
#     @offered_course.course = @course
#     @offered_course.creator = present_user
#     raise SecurityTransgression unless present_user.can_create?(@offered_course)    
# 
#     respond_to do |format|
#       if @offered_course.save
#         format.html { redirect_to @offered_course, notice: 'Offered course was successfully created.' }
#       else
#         format.html { render action: "new" }
#       end
#     end
#   end
# 
#   def update
#     @offered_course = OfferedCourse.find(params[:id])
#     raise SecurityTransgression unless present_user.can_update?(@offered_course)
# 
#     respond_to do |format|
#       if @offered_course.update_attributes(params[:offered_course])
#         format.html { redirect_to @offered_course, notice: 'Offered course was successfully updated.' }
#       else
#         format.html { render action: "edit" }
#       end
#     end
#   end
# 
#   def destroy
#     @offered_course = OfferedCourse.find(params[:id])
#     raise SecurityTransgression unless present_user.can_destroy?(@offered_course)
#     @offered_course.destroy
#     redirect_to offered_courses_url
#   end
#   
# protected
# 
#   def get_course
#     @course = Course.find(params[:course_id])
#   end
#   
#   def set_time_zone
#     Time.zone = params[:offered_course][:time_zone]
#   end
# end
