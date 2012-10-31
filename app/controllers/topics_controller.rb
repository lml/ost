# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.


class TopicsController < ApplicationController

  before_filter :get_learning_plan, :only => [:create]

  def edit
    @topic = Topic.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@topic)
  end

  def create
    @topic = Topic.new
    @topic.learning_plan = @learning_plan
    raise SecurityTransgression unless present_user.can_create?(@topic)  
    @topic.save
  end

  def update
    @topic = Topic.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@topic)

    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        format.json { respond_with_bip(@topic) }
      else
        format.json { respond_with_bip(@topic) }
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
