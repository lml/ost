# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.


class CoursesController < ApplicationController

  before_filter :get_organization, :only => [:index, :new, :create]

  def index
    @courses = Course.all
    raise SecurityTransgression unless present_user.can_read_children?(@organization, :courses)
  end

  def show
    @course = Course.find(params[:id])
    raise SecurityTransgression unless present_user.can_read?(@course)
  end

  def new
    @course = Course.new
    @course.organization = @organization
    raise SecurityTransgression unless present_user.can_create?(@course)
  end

  def edit
    @course = Course.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@course)
  end

  def create
    @course = Course.new(params[:course])
    @course.organization = @organization
    raise SecurityTransgression unless present_user.can_create?(@course)

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @course = Course.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@course)

    respond_to do |format|
      if @course.update_attributes(params[:course])
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @course = Course.find(params[:id])
    @course.destroy
    raise SecurityTransgression unless present_user.can_destroy?(@course)
    redirect_to organization_url(@course.organization)
  end
  
protected

  def get_organization
    @organization = Organization.find(params[:organization_id])
  end
  
end
