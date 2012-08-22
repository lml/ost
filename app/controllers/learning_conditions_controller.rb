
class LearningConditionsController < ApplicationController

  before_filter :get_klass, :only => [:index]

  def index
    # LCs are not really direct children of klass, but that's ok
    raise SecurityTransgression unless present_user.can_read_children?(@klass, :learning_conditions)
  end
  
protected

  def get_klass
    @klass = Klass.find(params[:klass_id])
  end
  
end
