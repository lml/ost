class FeedbackConditionsController < ApplicationController

  before_filter :get_learning_condition, :only => [:new, :create, :sort]

  def new
    raise SecurityTransgression unless present_user.can_update?(@learning_condition)
  end

  def create
    raise SecurityTransgression unless present_user.can_update?(@learning_condition)

    FeedbackCondition.transaction do
      case params[:type]
      when 'basic'
        BasicFeedbackCondition.create(:learning_condition => @learning_condition)
      else
        raise IllegalArgument
      end
    end
    
    redirect_to klass_learning_conditions_path(@learning_condition.cohort.klass) 
  end
  
  def edit
    @feedback_condition = FeedbackCondition.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@feedback_condition)
  end

  def update
    @feedback_condition = FeedbackCondition.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@feedback_condition)

    respond_to do |format|
      if @feedback_condition.update_attributes(params[:feedback_condition])
        format.html { redirect_to klass_learning_conditions_path(@feedback_condition.learning_condition.cohort.klass), 
                                  notice: 'Feedback condition was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @feedback_condition = FeedbackCondition.find(params[:id])
    raise SecurityTransgression unless present_user.can_destroy?(@feedback_condition)
    @feedback_condition.destroy
  end
  
  def sort
    super('feedback_condition', FeedbackCondition, @learning_condition, :learning_condition)
  end
  
  
protected

  def get_learning_condition
    @learning_condition = LearningCondition.find(params[:learning_condition_id])
  end

  
end
