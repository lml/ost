
class TopicExercisesController < ApplicationController

  before_filter :get_topic, :only => [:new, :create, :sort]

  def new
    @topic_exercise = TopicExercise.new(:topic => @topic, :exercise => Exercise.new)
  end

  def edit
    @topic_exercise = TopicExercise.find(params[:id])
  end

  def create
    @topic_exercise = TopicExercise.new(:topic => @topic)
    raise SecurityTransgression unless present_user.can_create?(@topic_exercise)

    begin
      @topic_exercise.update_url!(params[:exercise_url])
      @topic_exercise.save
    rescue Exception => invalid
      logger.error("An error occurred when creating a lesson exercise: #{invalid.message}")
      @topic_exercise.errors.add(:base, "This URL is no good.  Can you recheck?")
    end
    
    render :template => 'topic_exercises/create_update'
  end

  def update
    @topic_exercise = TopicExercise.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@topic_exercise)
    
    begin
      # Using a transaction here b/c the updates are a tad more complicated than
      # just updating some fields in a record (one of them involves a move from
      # one set to another, which means we need to update a few things)
      TopicExercise.transaction do
        @topic_exercise.update_url!(params[:exercise_url])
        @topic_exercise.update_concept!(params[:topic_exercise][:concept_id])
      end
    rescue ActiveRecord::RecordInvalid => invalid
      logger.error("An error occurred when updating a lesson exercise: #{invalid.message}")
    rescue Exception => invalid
      logger.error("An error occurred when updating a lesson exercise: #{invalid.message}")
      @topic_exercise.errors.add(:base, "An unknown error occurred when updating this exercise.")
    end  
    
    render :template => 'topic_exercises/create_update'
  end

  def destroy
    @topic_exercise = TopicExercise.find(params[:id])
    raise SecurityTransgression unless present_user.can_destroy?(@topic_exercise)
    @topic_exercise.destroy
  end
  
  def sort
    sorted_ids = params['sortable_item']
    return if sorted_ids.blank?
  
    topic_exercises = TopicExercise.find(sorted_ids)
  
    topic_exercises.each do |topic_exercise|
      raise SecurityTransgression unless topic_exercise.topic == @topic
      raise SecurityTransgression unless topic_exercise.can_be_sorted_by?(present_user)      
    end
    
    begin 
      TopicExercise.sort!(sorted_ids)
    rescue Exception => invalid
      flash[:alert] = "An error occurred: #{invalid.message}"
    end
  end
  
protected

  def get_topic
    @topic = Topic.find(params[:topic_id])
  end
  
end
