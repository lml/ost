
class PercentSchedulersController < ApplicationController
  # GET /percent_schedulers
  # GET /percent_schedulers.json
  def index
    @percent_schedulers = PercentScheduler.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @percent_schedulers }
    end
  end

  # GET /percent_schedulers/1
  # GET /percent_schedulers/1.json
  def show
    @percent_scheduler = PercentScheduler.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @percent_scheduler }
    end
  end

  # GET /percent_schedulers/new
  # GET /percent_schedulers/new.json
  def new
    @percent_scheduler = PercentScheduler.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @percent_scheduler }
    end
  end

  # GET /percent_schedulers/1/edit
  def edit
    @percent_scheduler = PercentScheduler.find(params[:id])
  end

  # POST /percent_schedulers
  # POST /percent_schedulers.json
  def create
    @percent_scheduler = PercentScheduler.new(params[:percent_scheduler])

    respond_to do |format|
      if @percent_scheduler.save
        format.html { redirect_to @percent_scheduler, notice: 'Percent scheduler was successfully created.' }
        format.json { render json: @percent_scheduler, status: :created, location: @percent_scheduler }
      else
        format.html { render action: "new" }
        format.json { render json: @percent_scheduler.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /percent_schedulers/1
  # PUT /percent_schedulers/1.json
  def update
    @percent_scheduler = PercentScheduler.find(params[:id])

    respond_to do |format|
      if @percent_scheduler.update_attributes(params[:percent_scheduler])
        format.html { redirect_to @percent_scheduler, notice: 'Percent scheduler was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @percent_scheduler.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /percent_schedulers/1
  # DELETE /percent_schedulers/1.json
  def destroy
    @percent_scheduler = PercentScheduler.find(params[:id])
    @percent_scheduler.destroy

    respond_to do |format|
      format.html { redirect_to percent_schedulers_url }
      format.json { head :no_content }
    end
  end
end
