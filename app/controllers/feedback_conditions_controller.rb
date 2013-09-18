class FeedbackConditionsController < ApplicationController

  before_filter :get_learning_condition

  def edit
    @feedback_condition = FeedbackCondition.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@learning_condition)
  end

  def update
    @feedback_condition = FeedbackCondition.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@learning_condition)

    respond_to do |format|
      if @feedback_condition.update_attributes(params[:feedback_condition])
        format.html { redirect_to klass_learning_conditions_path(@learning_condition.cohort.klass), 
                                  notice: 'Feedback condition was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

protected

  def get_learning_condition
    @learning_condition = (LearningConditionFeedbackCondition.where       {feedback_condition_id == my{params[:id]}}.first || 
                           LearningConditionDefaultFeedbackCondition.where{feedback_condition_id == my{params[:id]}}.first).learning_condition
  end
  
end
