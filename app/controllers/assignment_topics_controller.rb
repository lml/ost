
class AssignmentTopicsController < ApplicationController

  before_filter :get_assignment, :only => [:new, :create]

  def new
    @assignment_topic = AssignmentTopic.new(:assignment => @assignment)
    raise SecurityTransgression unless present_user.can_create?(@assignment_topic)
  end

  def create
    @assignment_topic = AssignmentTopic.new(params[:assignment_topic])
    @assignment_topic.assignment = @assignment
    raise SecurityTransgression unless present_user.can_create?(@assignment_topic)
    @assignment_topic.save
  end

  def destroy
    @assignment_topic = AssignmentTopic.find(params[:id])
    raise SecurityTransgression unless present_user.can_destroy?(@assignment_topic)
    @assignment_topic.destroy
  end
  
protected

  def get_assignment
    @assignment = Assignment.find(params[:assignment_id])
  end
  
end
