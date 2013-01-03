# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.


class LearningPlansController < ApplicationController

  def show
    @learning_plan = LearningPlan.find(params[:id])
    raise SecurityTransgression unless present_user.can_read?(@learning_plan)
  end
  
  def edit
    @learning_plan = LearningPlan.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@learning_plan)
  end

  def update
    @learning_plan = LearningPlan.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@learning_plan)

    respond_to do |format|
      if @learning_plan.update_attributes(params[:learning_plan])
        format.html { redirect_to @learning_plan, notice: 'Learning Plan was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def refresh_exercises
    @learning_plan = LearningPlan.find(params[:learning_plan_id])
    raise SecurityTransgression unless present_user.can_update?(@learning_plan)
    @learning_plan.clear_cached_exercise_content!
    flash[:notice] = "Exercise content has been refreshed"
  end
  
end
