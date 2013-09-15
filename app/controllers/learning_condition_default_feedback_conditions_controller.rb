class LearningConditionDefaultFeedbackConditionsController < ApplicationController

  before_filter :get_learning_condition_default_feedback_condition

  def edit
    raise SecurityTransgression unless present_user.can_update?(@lcdfc)
  end

  def update
    raise SecurityTransgression unless present_user.can_update?(@lcdfc)

    respond_to do |format|
      if @lcdfc.update_attributes(params[:learning_condition_default_feedback_condition])
        format.html { redirect_to klass_learning_conditions_path(@lcdfc.learning_condition.cohort.klass),
                                  notice: 'LC Default Feedback Condition was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

protected

  def get_learning_condition_default_feedback_condition
    @learning_condition_default_feedback_condition = LearningConditionDefaultFeedbackCondition.find(params[:id])
    @lcdfc = @learning_condition_default_feedback_condition
  end
end
