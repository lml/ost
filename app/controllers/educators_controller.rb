
class EducatorsController < ApplicationController
  # GET /educators
  # GET /educators.json
  def index
    @educators = Educator.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @educators }
    end
  end

  # GET /educators/1
  # GET /educators/1.json
  def show
    @educator = Educator.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @educator }
    end
  end

  # GET /educators/new
  # GET /educators/new.json
  def new
    @educator = Educator.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @educator }
    end
  end

  # GET /educators/1/edit
  def edit
    @educator = Educator.find(params[:id])
  end

  # POST /educators
  # POST /educators.json
  def create
    @educator = Educator.new(params[:educator])

    respond_to do |format|
      if @educator.save
        format.html { redirect_to @educator, notice: 'Educator was successfully created.' }
        format.json { render json: @educator, status: :created, location: @educator }
      else
        format.html { render action: "new" }
        format.json { render json: @educator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /educators/1
  # PUT /educators/1.json
  def update
    @educator = Educator.find(params[:id])

    respond_to do |format|
      if @educator.update_attributes(params[:educator])
        format.html { redirect_to @educator, notice: 'Educator was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @educator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /educators/1
  # DELETE /educators/1.json
  def destroy
    @educator = Educator.find(params[:id])
    @educator.destroy

    respond_to do |format|
      format.html { redirect_to educators_url }
      format.json { head :no_content }
    end
  end
end
