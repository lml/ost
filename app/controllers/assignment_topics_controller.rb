
class AssignmentTopicsController < ApplicationController
  # GET /assignment_topics
  # GET /assignment_topics.json
  def index
    @assignment_topics = AssignmentTopic.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @assignment_topics }
    end
  end

  # GET /assignment_topics/1
  # GET /assignment_topics/1.json
  def show
    @assignment_topic = AssignmentTopic.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @assignment_topic }
    end
  end

  # GET /assignment_topics/new
  # GET /assignment_topics/new.json
  def new
    @assignment_topic = AssignmentTopic.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @assignment_topic }
    end
  end

  # GET /assignment_topics/1/edit
  def edit
    @assignment_topic = AssignmentTopic.find(params[:id])
  end

  # POST /assignment_topics
  # POST /assignment_topics.json
  def create
    @assignment_topic = AssignmentTopic.new(params[:assignment_topic])

    respond_to do |format|
      if @assignment_topic.save
        format.html { redirect_to @assignment_topic, notice: 'Assignment topic was successfully created.' }
        format.json { render json: @assignment_topic, status: :created, location: @assignment_topic }
      else
        format.html { render action: "new" }
        format.json { render json: @assignment_topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /assignment_topics/1
  # PUT /assignment_topics/1.json
  def update
    @assignment_topic = AssignmentTopic.find(params[:id])

    respond_to do |format|
      if @assignment_topic.update_attributes(params[:assignment_topic])
        format.html { redirect_to @assignment_topic, notice: 'Assignment topic was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @assignment_topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assignment_topics/1
  # DELETE /assignment_topics/1.json
  def destroy
    @assignment_topic = AssignmentTopic.find(params[:id])
    @assignment_topic.destroy

    respond_to do |format|
      format.html { redirect_to assignment_topics_url }
      format.json { head :no_content }
    end
  end
end
