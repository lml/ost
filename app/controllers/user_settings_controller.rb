# Copyright 2011-2014 Rice University. Licensed under the Affero General Public
# License version 3 or later.  See the COPYRIGHT file for details.

class UserSettingsController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
    @settings = user_settings
  end

  def update
    @settings = user_settings
    respond_to do |format|
      if @settings.update_attributes(params[:settings])
        format.json { render json: {:success => true, message: 'Settings were successfully updated.'}}
      else
        Rails.logger.info(@settings.errors.messages.inspect)
        format.json { render json: {:success => false, message: 'Unable to update settings.'} }
      end
    end
  end
end
