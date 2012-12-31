# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class PresentationConditionsController < ApplicationController

  before_filter :get_learning_condition, :only => [:new, :create, :sort]

  def new
    raise SecurityTransgression unless present_user.can_update?(@learning_condition)    
  end

  def create
    raise SecurityTransgression unless present_user.can_update?(@learning_condition)

    PresentationCondition.create(:learning_condition => @learning_condition)
    
    redirect_to klass_learning_conditions_path(@learning_condition.cohort.klass) 
  end
  
  def edit
    @presentation_condition = PresentationCondition.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@presentation_condition)
  end

  def update
    @presentation_condition = PresentationCondition.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@presentation_condition)

    respond_to do |format|
      if @presentation_condition.update_attributes(params[:presentation_condition])
        format.html { redirect_to klass_learning_conditions_path(@presentation_condition.learning_condition.cohort.klass), 
                                  notice: 'Presentation condition was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @presentation_condition = PresentationCondition.find(params[:id])
    raise SecurityTransgression unless present_user.can_destroy?(@presentation_condition)
    @presentation_condition.destroy
  end
  
  def sort
    super('presentation_condition', PresentationCondition, @learning_condition, :learning_condition)
  end

protected

  def get_learning_condition
    @learning_condition = LearningCondition.find(params[:learning_condition_id])
  end

end
