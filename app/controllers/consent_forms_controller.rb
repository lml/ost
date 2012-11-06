# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.


class ConsentFormsController < ApplicationController

  def index
    raise SecurityTransgression unless present_user.can_list?(ConsentForm)
    @consent_forms = ConsentForm.all
  end

  def show
    @consent_form = ConsentForm.find(params[:id])
    raise SecurityTransgression unless present_user.can_read?(@consent_form)
  end

  def new
    @consent_form = ConsentForm.new
    raise SecurityTransgression unless present_user.can_create?(@consent_form)
  end

  def edit
    @consent_form = ConsentForm.find(params[:id])
    raise SecurityTransgression unless present_user.can_update?(@consent_form)
  end

  def create
    @consent_form = ConsentForm.new(params[:consent_form])

    raise SecurityTransgression unless present_user.can_create?(@consent_form)

    respond_to do |format|
      if @consent_form.save
        format.html { redirect_to(@consent_form, :notice => 'Consent form was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @consent_form = ConsentForm.find(params[:id])
    
    raise SecurityTransgression unless present_user.can_update?(@consent_form)

    respond_to do |format|
      if @consent_form.update_attributes(params[:consent_form])
        format.html { redirect_to(@consent_form, :notice => 'Consent form was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @consent_form = ConsentForm.find(params[:id])
    raise SecurityTransgression unless present_user.can_destroy?(@consent_form)
    @consent_form.destroy
    redirect_to(consent_forms_url)
  end
  
end
