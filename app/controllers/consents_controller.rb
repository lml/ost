class ConsentsController < ApplicationController
  # GET /consents
  # GET /consents.json
  def index
    @consents = Consent.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @consents }
    end
  end

  # GET /consents/1
  # GET /consents/1.json
  def show
    @consent = Consent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @consent }
    end
  end

  # GET /consents/new
  # GET /consents/new.json
  def new
    @consent = Consent.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @consent }
    end
  end

  # GET /consents/1/edit
  def edit
    @consent = Consent.find(params[:id])
  end

  # POST /consents
  # POST /consents.json
  def create
    @consent = Consent.new(params[:consent])

    respond_to do |format|
      if @consent.save
        format.html { redirect_to @consent, notice: 'Consent was successfully created.' }
        format.json { render json: @consent, status: :created, location: @consent }
      else
        format.html { render action: "new" }
        format.json { render json: @consent.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /consents/1
  # PUT /consents/1.json
  def update
    @consent = Consent.find(params[:id])

    respond_to do |format|
      if @consent.update_attributes(params[:consent])
        format.html { redirect_to @consent, notice: 'Consent was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @consent.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /consents/1
  # DELETE /consents/1.json
  def destroy
    @consent = Consent.find(params[:id])
    @consent.destroy

    respond_to do |format|
      format.html { redirect_to consents_url }
      format.json { head :no_content }
    end
  end
end
