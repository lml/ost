
class LearningConditionsController < ApplicationController
  # GET /learning_conditions
  # GET /learning_conditions.json
  def index
    @learning_conditions = LearningCondition.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @learning_conditions }
    end
  end

  # GET /learning_conditions/1
  # GET /learning_conditions/1.json
  def show
    @learning_condition = LearningCondition.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @learning_condition }
    end
  end

  # GET /learning_conditions/new
  # GET /learning_conditions/new.json
  def new
    @learning_condition = LearningCondition.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @learning_condition }
    end
  end

  # GET /learning_conditions/1/edit
  def edit
    @learning_condition = LearningCondition.find(params[:id])
  end

  # POST /learning_conditions
  # POST /learning_conditions.json
  def create
    @learning_condition = LearningCondition.new(params[:learning_condition])

    respond_to do |format|
      if @learning_condition.save
        format.html { redirect_to @learning_condition, notice: 'Learning condition was successfully created.' }
        format.json { render json: @learning_condition, status: :created, location: @learning_condition }
      else
        format.html { render action: "new" }
        format.json { render json: @learning_condition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /learning_conditions/1
  # PUT /learning_conditions/1.json
  def update
    @learning_condition = LearningCondition.find(params[:id])

    respond_to do |format|
      if @learning_condition.update_attributes(params[:learning_condition])
        format.html { redirect_to @learning_condition, notice: 'Learning condition was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @learning_condition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /learning_conditions/1
  # DELETE /learning_conditions/1.json
  def destroy
    @learning_condition = LearningCondition.find(params[:id])
    @learning_condition.destroy

    respond_to do |format|
      format.html { redirect_to learning_conditions_url }
      format.json { head :no_content }
    end
  end
end
