# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class ConsentOptionsController < ApplicationController

  def show
    @consent_options = ConsentOptions.find(params[:id])
    raise SecurityTransgression unless present_user.can_read?(@consent_options)
  end

  def edit
    @consent_options = ConsentOptions.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@consent_options)
  end

  def update
    @consent_options = ConsentOptions.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@consent_options)

    respond_to do |format|
      if @consent_options.update_attributes(params[:consent_options])
        format.html { redirect_to @consent_options, notice: 'Consent options was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

end
