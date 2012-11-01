# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.


class EducatorsController < ApplicationController

  before_filter :get_klass, :only => [:new, :search, :create]

  def new
    educator = Educator.new(:klass => @klass, 
                            :is_instructor => 'instructor' == params[:type],
                            :is_teaching_assistant => 'teaching_assistant' == params[:type],
                            :is_grader => 'grader' == params[:type])
                            
    raise SecurityTransgression unless present_user.can_create?(educator)
    
    @action_dialog_title = "Add #{params[:type].titleize.pluralize}"
    @action_search_path = 
      case params[:type] 
      when 'instructor' 
        search_instructors_klass_educators_path(@klass)
      when 'teaching_assistant'
        search_assistants_klass_educators_path(@klass)
      when 'grader'
        search_graders_klass_educators_path(@klass)
      else
        raise IllegalArgument
      end
    
    respond_to do |format|
      format.js { render :template => 'users/action_new' }
    end
  end
  
  def search
    @selected_type = params[:selected_type]
    @text_query = params[:text_query]
    @users = User.search(@selected_type, @text_query)

    # Don't show existing instructors
    existing_user_ids = @klass.educators.collect{|e| e.user.id}
    @users.reject! {|user| existing_user_ids.any?{|eui| eui == user.id}}
    
    @action_partial = 'educators/create_educator_form'
    
    respond_to do |format|
      format.js { render :template => 'users/action_search' }
    end
  end

  def edit
    @educator = Educator.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@educator)
  end

  def create
    @educator = Educator.new(params[:educator])
    @educator.klass = @klass
    raise SecurityTransgression unless present_user.can_create?(@educator)

    respond_to do |format|
      if @educator.save
        format.js
      else
        flash[:alert] = @educator.errors.values.to_sentence
        format.js { render :template => 'shared/display_flash' }
      end
    end
  end

  def update
    @educator = Educator.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@educator)

    respond_to do |format|
      if @educator.update_attributes(params[:educator])
        format.html { redirect_to @educator.klass, notice: 'Educator was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @educator = Educator.find(params[:id])
    raise SecurityTransgression unless present_user.can_destroy?(@educator)
    @educator.destroy
    redirect_to klass_path(@educator.klass)
  end
  
protected

  def get_klass
    @klass = Klass.find(params[:klass_id])
  end
  
end
