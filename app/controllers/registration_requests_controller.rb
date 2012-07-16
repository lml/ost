
class RegistrationRequestsController < ApplicationController
  # GET /registration_requests
  # GET /registration_requests.json
  def index
    @registration_requests = RegistrationRequest.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @registration_requests }
    end
  end

  # GET /registration_requests/1
  # GET /registration_requests/1.json
  def show
    @registration_request = RegistrationRequest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @registration_request }
    end
  end

  # GET /registration_requests/new
  # GET /registration_requests/new.json
  def new
    @registration_request = RegistrationRequest.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @registration_request }
    end
  end

  # GET /registration_requests/1/edit
  def edit
    @registration_request = RegistrationRequest.find(params[:id])
  end

  # POST /registration_requests
  # POST /registration_requests.json
  def create
    @registration_request = RegistrationRequest.new(params[:registration_request])

    respond_to do |format|
      if @registration_request.save
        format.html { redirect_to @registration_request, notice: 'Registration request was successfully created.' }
        format.json { render json: @registration_request, status: :created, location: @registration_request }
      else
        format.html { render action: "new" }
        format.json { render json: @registration_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /registration_requests/1
  # PUT /registration_requests/1.json
  def update
    @registration_request = RegistrationRequest.find(params[:id])

    respond_to do |format|
      if @registration_request.update_attributes(params[:registration_request])
        format.html { redirect_to @registration_request, notice: 'Registration request was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @registration_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /registration_requests/1
  # DELETE /registration_requests/1.json
  def destroy
    @registration_request = RegistrationRequest.find(params[:id])
    @registration_request.destroy

    respond_to do |format|
      format.html { redirect_to registration_requests_url }
      format.json { head :no_content }
    end
  end
end
