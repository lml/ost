class LearningConditionFeedbackConditionsController < ApplicationController

  before_filter :get_learning_condition_feedback_condition, only: [ :edit, :update, :destroy ]
  before_filter :get_learning_condition,                    only: [ :create, :sort ]

  def create
    raise SecurityTransgression unless present_user.can_update?(@learning_condition)
    LearningConditionFeedbackCondition.create! learning_condition: @learning_condition,
                                               feedback_condition: FeedbackCondition.standard_practice_feedback_condition
    redirect_to klass_learning_conditions_path(@learning_condition.cohort.klass)
  end

  def edit
    raise SecurityTransgression unless present_user.can_update?(@lcfc)
  end

  def update
    raise SecurityTransgression unless present_user.can_update?(@lcfc)

    respond_to do |format|
      if @lcfc.update_attributes(params[:learning_condition_feedback_condition])
        format.html { redirect_to klass_learning_conditions_path(@lcfc.learning_condition.cohort.klass),
                                  notice: 'LC Feedback Condition was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    raise SecurityTransgression unless present_user.can_destroy?(@lcfc)
    @lcfc.destroy
  end

  def sort
    super('learning_condition_feedback_condition', LearningConditionFeedbackCondition,
          @learning_condition, :learning_condition)
  end

protected

  def get_learning_condition_feedback_condition
    @learning_condition_feedback_condition = LearningConditionFeedbackCondition.find(params[:id])
    @lcfc = @learning_condition_feedback_condition
  end

  def get_learning_condition
    @learning_condition = LearningCondition.find(params[:learning_condition_id])
  end
end
