
class StudentsController < ApplicationController

  before_filter :get_klass, :only => [:index]

  def index
    raise SecurityTransgression unless present_user.can_read_children?(@klass, :students)
  end

  def show
    @student = Student.find(params[:id])
    raise SecurityTransgression unless present_user.can_read?(@student)
  end

  def update
    @student = Student.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@student)
    @student.update_attributes(params[:student])
    redirect_to @student
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
