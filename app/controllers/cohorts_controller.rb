
class CohortsController < ApplicationController

  before_filter :get_section, :only => [:index, :new, :create]

  def index
    @cohorts = @section.cohorts
  end

  def show
    @cohort = Cohort.find(params[:id])
  end

  def new
    @cohort = Cohort.new(:section => @section)  
  end

  def edit
    @cohort = Cohort.find(params[:id])
  end

  def create
    @cohort = Cohort.new(params[:cohort])
    @cohort.section = @section

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

  def get_section
    @section = Section.find(params[:section_id])
  end

end
