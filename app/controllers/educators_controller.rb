
class EducatorsController < ApplicationController

  before_filter :get_klass, :only => [:new]

  def new
    educator = Educator.new(:klass => @klass)
    raise SecurityTransgression unless present_user.can_create?(educator)
    
    @action_dialog_title = "Add an educator"
    @action_search_path = search_klass_educators_path
    
    respond_to do |format|
      format.js { render :template => 'users/action_new' }
    end
  end

  def edit
    @educator = Educator.find(params[:id])
    raise NotYetImplemented
  end

  def create
    @educator = Educator.new(params[:educator])
    raise SecurityTransgression unless present_user.can_create?(@educator)

    respond_to do |format|
      if @educator.save
        format.html { redirect_to @educator, notice: 'Educator was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @educator = Educator.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@educator)

    respond_to do |format|
      if @educator.update_attributes(params[:educator])
        format.html { redirect_to @educator, notice: 'Educator was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @educator = Educator.find(params[:id])
    raise SecurityTransgression unless present_user.can_destroy?(@educator)
    @educator.destroy
    redirect_to educators_url
  end
  
protected

  def get_klass
    @klass = Klass.find(params[:klass])
  end
  
end
