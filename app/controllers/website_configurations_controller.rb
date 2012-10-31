class WebsiteConfigurationsController < ApplicationController

  before_filter :authenticate_admin!
  before_filter :load, :only => [:index, :edit]
  before_filter :prepare

  def index
  end

  def edit
  end

  def update
    begin
      WebsiteConfiguration.transaction do
        @website_configurations.each do |configuration|
          configuration.update_attribute(:value, params[configuration.name])
        end
      end
      redirect_to(website_configurations_path,
                  :notice => 'Website configuration was successfully updated.')
    rescue ActiveRecord::RecordInvalid => invalid
      render :action => "edit", :notice => 'An error has occurred.'
    end
  end

protected

  def load
    WebsiteConfiguration.load
  end

  def prepare
    raise SecurityTransgression unless present_user.can_read?(WebsiteConfiguration)
    @website_configurations = WebsiteConfiguration.all
  end

end
