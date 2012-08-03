
class TopicsController < ApplicationController

  before_filter :get_learning_plan, :only => [:create]

  # def new
  #   
  # end

  def edit
    @topic = Topic.find(params[:id])
  end

  def create
    @topic = Topic.new
    @topic.learning_plan = @learning_plan
    raise SecurityTransgression unless present_user.can_create?(@topic)  
    @topic.save
  end

  def update
    @topic = Topic.find(params[:id])

    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        format.html { redirect_to @topic, notice: 'Topic was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy

    respond_to do |format|
      format.html { redirect_to topics_url }
      format.json { head :no_content }
    end
  end
  
protected

  def get_learning_plan
    @learning_plan = LearningPlan.find(params[:learning_plan_id])
  end

end
