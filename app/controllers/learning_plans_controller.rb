
class LearningPlansController < ApplicationController

  def show
    @learning_plan = LearningPlan.find(params[:id])
    raise SecurityTransgression unless present_user.can_read?(@learning_plan)
  end
  
end
