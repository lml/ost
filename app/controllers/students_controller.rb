
class StudentsController < ApplicationController

  before_filter :get_klass, :only => [:index]

  def index
  end

  def show
    @student = Student.find(params[:id])
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
  
  def drop
    @student = Student.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@student)
    @student.drop!
    redirect_to @student.section.klass
  end

protected

  def get_klass
    @klass = Klass.find(params[:klass_id])
  end
end
