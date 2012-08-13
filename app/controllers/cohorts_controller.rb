
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
  end

  def edit
    @cohort = Cohort.find(params[:id])
  end

  def create
    @cohort = Cohort.new(params[:cohort])
    @cohort.klass = @klass

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
    @cohort.destroy
  end
  
protected

  def get_klass
    @klass = Klass.find(params[:klass_id])
  end

end
