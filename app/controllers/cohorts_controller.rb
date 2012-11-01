# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.


class CohortsController < ApplicationController

  before_filter :get_klass, :only => [:index, :new, :create]

  def index
    @cohorts = @klass.cohorts
    raise SecurityTransgression unless present_user.can_read_children?(@klass, :cohorts)
  end

  def show
    @cohort = Cohort.find(params[:id])
    raise SecurityTransgression unless present_user.can_read?(@cohort)
  end

  def new
    @cohort = Cohort.new(:klass => @klass)  
    raise SecurityTransgression unless present_user.can_create?(@cohort)
  end

  def edit
    @cohort = Cohort.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@cohort)
  end

  def create
    @cohort = Cohort.new(params[:cohort])
    @cohort.klass = @klass
    
    raise SecurityTransgression unless present_user.can_create?(@cohort)

    respond_to do |format|
      if @cohort.save
        format.html { redirect_to @cohort, notice: 'Cohort was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @cohort = Cohort.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@cohort)

    respond_to do |format|
      if @cohort.update_attributes(params[:cohort])
        format.html { redirect_to @cohort, notice: 'Cohort was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @cohort = Cohort.find(params[:id])
    raise SecurityTransgression unless present_user.can_destroy?(@cohort)
    
    @cohort.destroy
    
    redirect_to klass_cohorts_path(@cohort.klass)
  end
  
protected

  def get_klass
    @klass = Klass.find(params[:klass_id])
  end

end
