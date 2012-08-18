class SiteLicensesController < ApplicationController

  before_filter :authenticate_admin!

  def index
    @site_licenses = SiteLicense.order{created_at.desc}.all
  end

  def show
    @site_license = SiteLicense.find(params[:id])
  end

  def new
    @site_license = SiteLicense.new
    raise SecurityTransgression unless present_user.can_create?(@site_license)
  end

  def edit
    @site_license = SiteLicense.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@site_license)
  end

  def create
    @site_license = SiteLicense.new(params[:site_license])

    respond_to do |format|
      if @site_license.save
        format.html { redirect_to @site_license, notice: 'Site license was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @site_license = SiteLicense.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@site_license)

    respond_to do |format|
      if @site_license.update_attributes(params[:site_license])
        format.html { redirect_to @site_license, notice: 'Site license was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @site_license = SiteLicense.find(params[:id])
    raise SecurityTransgression unless present_user.can_destroy?(@site_license)
    @site_license.destroy
    redirect_to site_licenses_url
  end
end
