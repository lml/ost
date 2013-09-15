class LearningConditionDefaultPresentationConditionsController < ApplicationController

  before_filter :get_learning_condition_default_presentation_condition

  def edit
    raise SecurityTransgression unless present_user.can_update?(@lcdpc)
  end

  def update
    raise SecurityTransgression unless present_user.can_update?(@lcdpc)

    respond_to do |format|
      if @lcdpc.update_attributes(params[:learning_condition_default_presentation_condition])
        format.html { redirect_to klass_learning_conditions_path(@lcdpc.learning_condition.cohort.klass),
                                  notice: 'LC Default Presentation Condition was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

protected

  def get_learning_condition_default_presentation_condition
    @learning_condition_default_presentation_condition = LearningConditionDefaultPresentationCondition.find(params[:id])
    @lcdpc = @learning_condition_default_presentation_condition
  end
end
