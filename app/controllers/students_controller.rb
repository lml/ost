# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.


class StudentsController < ApplicationController

  before_filter :get_klass, :only => [:index]
  before_filter :raise_if_terp_only

  def index
    raise SecurityTransgression unless present_user.can_read_children?(@klass, :students)
  end

  def show
    @student = Student.find(params[:id])
    raise SecurityTransgression unless present_user.can_read?(@student)
  end
  
  def edit
    @student = Student.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@student)    
  end

  def update
    @student = Student.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@student)
    if @student.update_attributes(params[:student])
      redirect_to @student,  notice: 'Student was successfully updated.'
    else
      render :action => 'edit'
    end
  end
  
  def drop
    @student = Student.find(params[:id])
    raise SecurityTransgression unless present_user.id == @student.user_id
    @student.drop!
    redirect_to root_path
  end
  
protected

  def get_klass
    @klass = Klass.find(params[:klass_id])
  end

  def raise_if_terp_only
    raise SecurityTransgression if @student.try(:terp_only)
  end
end
