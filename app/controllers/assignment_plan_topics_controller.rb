
class AssignmentPlanTopicsController < ApplicationController

  before_filter :get_assignment_plan, :only => [:new, :create]

  def new
    @assignment_plan_topic = AssignmentPlanTopic.new(:assignment_plan => @assignment_plan)
    raise SecurityTransgression unless present_user.can_create?(@assignment_plan_topic)
    
    @existing_topics = @assignment_plan.topics
    @available_topics = @assignment_plan.learning_plan.topics.reject{|t| @existing_topics.include?(t)}
  end

  def create
    @assignment_plan_topic = AssignmentPlanTopic.new(params[:assignment_plan_topic])
    @assignment_plan_topic.assignment_plan = @assignment_plan
    raise SecurityTransgression unless present_user.can_create?(@assignment_plan_topic)
    @assignment_plan_topic.save
  end
  
  def update
    @assignment_plan_topic = AssignmentPlanTopic.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@assignment_plan_topic)

    respond_to do |format|
      if @assignment_plan_topic.update_attributes(params[:assignment_plan_topic])
        format.json { respond_with_bip(@assignment_plan_topic) }
      else
        format.json { respond_with_bip(@assignment_plan_topic) }
      end
    end
  end

  def destroy
    @assignment_plan_topic = AssignmentPlanTopic.find(params[:id])
    raise SecurityTransgression unless present_user.can_destroy?(@assignment_plan_topic)
    @assignment_plan_topic.destroy
  end
  
protected

  def get_assignment_plan
    @assignment_plan = AssignmentPlan.find(params[:assignment_plan_id])
  end
  
end
