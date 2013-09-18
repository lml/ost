class PresentationConditionsController < ApplicationController

  before_filter :get_learning_condition

  def edit
    @presentation_condition = PresentationCondition.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@learning_condition)
  end

  def update
    @presentation_condition = PresentationCondition.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@learning_condition)

    respond_to do |format|
      if @presentation_condition.update_attributes(params[:presentation_condition])
        format.html { redirect_to klass_learning_conditions_path(@learning_condition.cohort.klass), 
                                  notice: 'Feedback condition was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

protected

  def get_learning_condition
    @learning_condition = (LearningConditionPresentationCondition.where       {presentation_condition_id == my{params[:id]}}.first || 
                           LearningConditionDefaultPresentationCondition.where{presentation_condition_id == my{params[:id]}}.first).learning_condition
  end
  
end
