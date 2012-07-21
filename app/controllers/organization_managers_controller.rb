
class OrganizationManagersController < ApplicationController
  # GET /organization_managers
  # GET /organization_managers.json
  def index
    @organization_managers = OrganizationManager.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @organization_managers }
    end
  end

  # GET /organization_managers/1
  # GET /organization_managers/1.json
  def show
    @organization_manager = OrganizationManager.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @organization_manager }
    end
  end

  # GET /organization_managers/new
  # GET /organization_managers/new.json
  def new
    @organization_manager = OrganizationManager.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @organization_manager }
    end
  end

  # GET /organization_managers/1/edit
  def edit
    @organization_manager = OrganizationManager.find(params[:id])
  end

  # POST /organization_managers
  # POST /organization_managers.json
  def create
    @organization_manager = OrganizationManager.new(params[:organization_manager])

    respond_to do |format|
      if @organization_manager.save
        format.html { redirect_to @organization_manager, notice: 'Organization manager was successfully created.' }
        format.json { render json: @organization_manager, status: :created, location: @organization_manager }
      else
        format.html { render action: "new" }
        format.json { render json: @organization_manager.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /organization_managers/1
  # PUT /organization_managers/1.json
  def update
    @organization_manager = OrganizationManager.find(params[:id])

    respond_to do |format|
      if @organization_manager.update_attributes(params[:organization_manager])
        format.html { redirect_to @organization_manager, notice: 'Organization manager was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @organization_manager.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organization_managers/1
  # DELETE /organization_managers/1.json
  def destroy
    @organization_manager = OrganizationManager.find(params[:id])
    @organization_manager.destroy

    respond_to do |format|
      format.html { redirect_to organization_managers_url }
      format.json { head :no_content }
    end
  end
end
