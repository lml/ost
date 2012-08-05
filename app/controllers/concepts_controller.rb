
class ConceptsController < ApplicationController

  before_filter :get_learning_plan, :only => [:index, :new, :create, :sort]

  def index
    @concepts = @learning_plan.concepts
    raise SecurityTransgression unless present_user.can_read_children?(@learning_plan, :concepts)
  end

  def show
    @concept = Concept.find(params[:id])
    raise SecurityTransgression unless present_user.can_read?(@concept)
  end

  def new
    @concept = Concept.new(:learning_plan => @learning_plan)
    raise SecurityTransgression unless present_user.can_create?(@concept)
  end

  def edit
    @concept = Concept.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@concept)
  end

  def create
    @concept = Concept.new(params[:concept])
    @concept.learning_plan = @learning_plan
    
    raise SecurityTransgression unless present_user.can_create?(@concept)

    @concept.save
        
    render :template => 'concepts/create_update'
  end

  def update
    @concept = Concept.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@concept)

    @concept.update_attributes(params[:concept])

    render :template => 'concepts/create_update'
  end

  def destroy
    @concept = Concept.find(params[:id])
    raise SecurityTransgression unless present_user.can_destroy?(@concept)
    @concept.destroy
  end
  
  def sort
    sorted_ids = params['sortable_item']
    return if sorted_ids.blank?

    sorted_ids.each do |sorted_id|
      concept = Concept.find(sorted_id)
      raise SecurityTransgression unless concept.learning_plan == @learning_plan
      raise SecurityTransgression unless concept.can_be_sorted_by?(present_user)
    end

    begin 
      Concept.sort!(sorted_ids)
    rescue
      flash[:alert] = "An unknown error occurred."
    end
  end
  
  
protected

  def get_learning_plan
    @learning_plan = LearningPlan.find(params[:learning_plan_id])
  end
end
