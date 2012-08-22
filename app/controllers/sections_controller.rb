
class SectionsController < ApplicationController

  before_filter :get_klass, :only => [:index, :new, :create]

  def index
    raise SecurityTransgression unless present_user.can_read_children?(@klass, :sections)
    @sections = @klass.sections
  end

  def show
    @section = Section.find(params[:id])
    raise SecurityTransgression unless present_user.can_read?(@section)
  end

  def new
    @section = Section.new
    raise SecurityTransgression unless present_user.can_create?(@section)
  end

  def edit
    @section = Section.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@section)
  end

  def create
    @section = Section.new(params[:section])
    @section.klass = @klass
    raise SecurityTransgression unless present_user.can_create?(@section)

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
    raise SecurityTransgression unless present_user.can_update?(@section)

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
    raise SecurityTransgression unless present_user.can_destroy?(@section)
    @section.destroy
    redirect_to klass_sections_path(@section.klass)
  end
  
protected

  def get_klass
    @klass = Klass.find(params[:klass_id])
  end

end
