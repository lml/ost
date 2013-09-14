class LearningConditionPresentationConditionsController < ApplicationController

  before_filter :get_learning_condition_presentation_condition, only: [ :edit, :update, :destroy ]
  before_filter :get_learning_condition,                        only: [ :create, :sort ]

  def create
    raise SecurityTransgression unless present_user.can_update?(@learning_condition)
    LearningConditionPresentationCondition.create! learning_condition:     @learning_condition,
                                                   presentation_condition: PresentationCondition.standard_practice_presentation_condition
    redirect_to klass_learning_conditions_path(@learning_condition.cohort.klass)
  end

  def edit
    raise SecurityTransgression unless present_user.can_update?(@lcpc)
  end

  def update
    raise SecurityTransgression unless present_user.can_update?(@lcpc)

    respond_to do |format|
      if @lcpc.update_attributes(params[:learning_condition_presentation_condition])
        format.html { redirect_to klass_learning_conditions_path(@lcpc.learning_condition.cohort.klass),
                                  notice: 'LC Presentation Condition was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    raise SecurityTransgression unless present_user.can_destroy?(@lcpc)
    @lcpc.destroy
  end

  def sort
    super('learning_condition_presentation_condition', LearningConditionPresentationCondition,
          @learning_condition, :learning_condition)
  end

protected

  def get_learning_condition_presentation_condition
    @learning_condition_presentation_condition = LearningConditionPresentationCondition.find(params[:id])
    @lcpc = @learning_condition_presentation_condition
  end

  def get_learning_condition
    @learning_condition = LearningCondition.find(params[:learning_condition_id])
  end
end
