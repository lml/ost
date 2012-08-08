
class AssignmentPlansController < ApplicationController

  before_filter :get_learning_plan, :only => [:new, :create, :sort]

  def show
    @assignment_plan = AssignmentPlan.find(params[:id])
    raise SecurityTransgression unless present_user.can_read?(@assignment_plan)
  end

  def new
    @assignment_plan = AssignmentPlan.new(:learning_plan => @learning_plan)
    raise SecurityTransgression unless present_user.can_create?(@assignment_plan)
  end

  def edit
    @assignment_plan = AssignmentPlan.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@assignment_plan)
  end

  def create
    @assignment_plan = AssignmentPlan.new(params[:assignment_plan])
    @assignment_plan.learning_plan = @learning_plan
    raise SecurityTransgression unless present_user.can_create?(@assignment_plan)
    @assignment_plan.save
  end

  def update
    @assignment_plan = AssignmentPlan.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@assignment_plan)
    
    respond_to do |format|
      if @assignment_plan.update_attributes(params[:assignment_plan])
        format.js
        format.json
      else
        format.js
        format.json { render json: @assignment_plan.errors.values.to_sentence, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @assignment_plan = AssignmentPlan.find(params[:id])
    raise SecurityTransgression unless present_user.can_destroy?(@assignment_plan)
    @assignment_plan.destroy
  end
  
protected

  def get_learning_plan
    @learning_plan = LearningPlan.find(params[:learning_plan_id])
  end
end
