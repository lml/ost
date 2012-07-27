
class SectionsController < ApplicationController

  before_filter :get_klass, :only => [:index, :new, :create]

  def index
    @sections = @klass.sections
  end

  def show
    @section = Section.find(params[:id])
  end

  def new
    @section = Section.new
  end

  def edit
    @section = Section.find(params[:id])
  end

  def create
    @section = Section.new(params[:section])

    respond_to do |format|
      if @section.save
        format.html { redirect_to @section, notice: 'Section was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @section = Section.find(params[:id])

    respond_to do |format|
      if @section.update_attributes(params[:section])
        format.html { redirect_to @section, notice: 'Section was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @section = Section.find(params[:id])
    @section.destroy
    redirect_to klass_sections_path(@section.klass)
  end
  
protected

  def get_klass
    @klass = Klass.find(params[:klass_id])
  end

end
