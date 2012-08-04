
class TopicsController < ApplicationController

  before_filter :get_learning_plan, :only => [:create]

  def edit
    @topic = Topic.find(params[:id])
  end

  def create
    @topic = Topic.new
    @topic.learning_plan = @learning_plan
    raise SecurityTransgression unless present_user.can_create?(@topic)  
    @topic.save
    logger.debug(@topic.errors.inspect)
  end

  def update
    @topic = Topic.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@topic)

    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        format.html { redirect_to @topic, notice: 'Topic was successfully updated.' }
        format.json { respond_with_bip(@topic) }
      else
        # format.html { render action: "edit" }
        format.json { respond_with_bip(@topic) }
        # flash[:alert] = "Uh oh"
        # format.json
      end
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    raise SecurityTransgression unless present_user.can_destroy?(@topic)
    @topic.destroy
  end
  
protected

  def get_learning_plan
    @learning_plan = LearningPlan.find(params[:learning_plan_id])
  end

end
