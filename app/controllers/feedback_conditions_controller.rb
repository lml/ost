class FeedbackConditionsController < ApplicationController
  # GET /feedback_conditions
  # GET /feedback_conditions.json
  def index
    @feedback_conditions = FeedbackCondition.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @feedback_conditions }
    end
  end

  # GET /feedback_conditions/1
  # GET /feedback_conditions/1.json
  def show
    @feedback_condition = FeedbackCondition.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feedback_condition }
    end
  end

  # GET /feedback_conditions/new
  # GET /feedback_conditions/new.json
  def new
    @feedback_condition = FeedbackCondition.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @feedback_condition }
    end
  end

  # GET /feedback_conditions/1/edit
  def edit
    @feedback_condition = FeedbackCondition.find(params[:id])
  end

  # POST /feedback_conditions
  # POST /feedback_conditions.json
  def create
    @feedback_condition = FeedbackCondition.new(params[:feedback_condition])

    respond_to do |format|
      if @feedback_condition.save
        format.html { redirect_to @feedback_condition, notice: 'Feedback condition was successfully created.' }
        format.json { render json: @feedback_condition, status: :created, location: @feedback_condition }
      else
        format.html { render action: "new" }
        format.json { render json: @feedback_condition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /feedback_conditions/1
  # PUT /feedback_conditions/1.json
  def update
    @feedback_condition = FeedbackCondition.find(params[:id])

    respond_to do |format|
      if @feedback_condition.update_attributes(params[:feedback_condition])
        format.html { redirect_to @feedback_condition, notice: 'Feedback condition was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @feedback_condition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feedback_conditions/1
  # DELETE /feedback_conditions/1.json
  def destroy
    @feedback_condition = FeedbackCondition.find(params[:id])
    @feedback_condition.destroy

    respond_to do |format|
      format.html { redirect_to feedback_conditions_url }
      format.json { head :no_content }
    end
  end
end
