
class AssignmentsController < ApplicationController

  before_filter :get_learning_plan, :only => [:new, :create, :sort]

  def show
    @assignment = Assignment.find(params[:id])
    raise SecurityTransgression unless present_user.can_read?(@assignment)
  end

  def new
    @assignment = Assignment.new(:learning_plan => @learning_plan)
    raise SecurityTransgression unless present_user.can_create?(@assignment)
  end

  def edit
    @assignment = Assignment.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@assignment)
  end

  def create
    @assignment = Assignment.new(params[:assignment])
    @assignment.learning_plan = @learning_plan
    raise SecurityTransgression unless present_user.can_create?(@assignment)
    @assignment.save
  end

  def update
    @assignment = Assignment.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@assignment)
    
    respond_to do |format|
      if @assignment.update_attributes(params[:assignment])
        format.js
        format.json
      else
        format.js
        format.json { render json: @assignment.errors.values.to_sentence, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @assignment = Assignment.find(params[:id])
    raise SecurityTransgression unless present_user.can_destroy?(@assignment)
    @assignment.destroy
  end
  
protected

  def get_learning_plan
    @learning_plan = LearningPlan.find(params[:learning_plan_id])
  end
end
