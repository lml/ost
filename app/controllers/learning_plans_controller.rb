
class LearningPlansController < ApplicationController

  def show
    @learning_plan = LearningPlan.find(params[:id])
    raise SecurityTransgression unless present_user.can_read?(@learning_plan)
  end
  
  def refresh_exercises
    @learning_plan = LearningPlan.find(params[:learning_plan_id])
    raise SecurityTransgression unless present_user.can_update?(@learning_plan)
    @learning_plan.clear_cached_exercise_content!
    flash[:notice] = "Exercise content has been refreshed"
  end
  
end
