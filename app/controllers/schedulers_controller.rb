
class SchedulersController < ApplicationController
  
  before_filter :get_learning_condition, :only => [:new, :create]
  
  def new
    raise SecurityTransgression unless present_user.can_update?(@learning_condition)
  end

  def create
    raise SecurityTransgression unless present_user.can_update?(@learning_condition)

    Scheduler.transaction do
      @learning_condition.scheduler.destroy if !@learning_condition.scheduler.nil?
      
      case params[:type]
      when 'percent'
        PercentScheduler.create(:learning_condition => @learning_condition)
      else
        raise IllegalArgument
      end
    end
    
    redirect_to klass_learning_conditions_path(@learning_condition.cohort.klass)
  end

  def edit
    @scheduler = Scheduler.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@scheduler)
  end

  def update
    @scheduler = Scheduler.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@scheduler)

    raise SecurityTransgression unless @scheduler.type == params[:type]
    
    case params[:type]
    when 'PercentScheduler'
      params[:scheduler][:schedules] = params[:scheduler][:schedules].values
    else
      raise IllegalArgument
    end    
    
    respond_to do |format|
      if @scheduler.update_attributes(params[:scheduler])
        format.html { redirect_to klass_learning_conditions_path(@scheduler.learning_condition.cohort.klass), notice: 'Schedule was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
    
  end
  
protected

  def get_learning_condition
    @learning_condition = LearningCondition.find(params[:learning_condition_id])
  end
  
end
