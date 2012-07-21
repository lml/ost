
class LearningPlansController < ApplicationController
  # GET /learning_plans
  # GET /learning_plans.json
  def index
    @learning_plans = LearningPlan.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @learning_plans }
    end
  end

  # GET /learning_plans/1
  # GET /learning_plans/1.json
  def show
    @learning_plan = LearningPlan.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @learning_plan }
    end
  end

  # GET /learning_plans/new
  # GET /learning_plans/new.json
  def new
    @learning_plan = LearningPlan.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @learning_plan }
    end
  end

  # GET /learning_plans/1/edit
  def edit
    @learning_plan = LearningPlan.find(params[:id])
  end

  # POST /learning_plans
  # POST /learning_plans.json
  def create
    @learning_plan = LearningPlan.new(params[:learning_plan])

    respond_to do |format|
      if @learning_plan.save
        format.html { redirect_to @learning_plan, notice: 'Learning plan was successfully created.' }
        format.json { render json: @learning_plan, status: :created, location: @learning_plan }
      else
        format.html { render action: "new" }
        format.json { render json: @learning_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /learning_plans/1
  # PUT /learning_plans/1.json
  def update
    @learning_plan = LearningPlan.find(params[:id])

    respond_to do |format|
      if @learning_plan.update_attributes(params[:learning_plan])
        format.html { redirect_to @learning_plan, notice: 'Learning plan was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @learning_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /learning_plans/1
  # DELETE /learning_plans/1.json
  def destroy
    @learning_plan = LearningPlan.find(params[:id])
    @learning_plan.destroy

    respond_to do |format|
      format.html { redirect_to learning_plans_url }
      format.json { head :no_content }
    end
  end
end
