
class ClassesController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index]
  before_filter :get_course, :only => [:new, :create]
  before_filter :set_time_zone, :only => [:create, :update]

  def index
    @klasses = Klass.where{end_date > Time.zone.now}
  end

  def show
    @klass = Klass.find(params[:id])
    raise SecurityTransgression unless present_user.can_read?(@klass)
  end

  def new
    @klass = Klass.new
    @klass.course = @course

    redirect_to catalog_path, :alert => "A manager at #{@course.organization.name} needs to give you permission to teach this class." \
      unless present_user.can_create?(@klass)
  end

  def help; end

  def edit
    @klass = Klass.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@klass)
  end

  def create
    @klass = Klass.new(params[:klass])
    @klass.course = @course
    @klass.creator = present_user
    raise SecurityTransgression unless present_user.can_create?(@klass)    

    respond_to do |format|
      if @klass.save
        format.html { redirect_to @klass, notice: 'Class was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @klass = Klass.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@klass)

    respond_to do |format|
      if @klass.update_attributes(params[:klass])
        format.html { redirect_to @klass, notice: 'Class was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @klass = Klass.find(params[:id])
    raise SecurityTransgression unless present_user.can_destroy?(@klass)
    @klass.destroy
    redirect_to klasses_url
  end

protected

  def get_course
    @course = Course.find(params[:course_id])
  end

  def set_time_zone
    Time.zone = params[:klass][:time_zone]
  end

end
