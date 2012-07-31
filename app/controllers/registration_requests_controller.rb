
class RegistrationRequestsController < ApplicationController

  before_filter :get_klass, :only => [:index, :new]
  before_filter :teaching_assistant_and_up_required!, :only => [:index]

  respond_to :html, :js

  def index
  end
  
  def new
    @registration_request = RegistrationRequest.new
  end

  def create
    @registration_request = RegistrationRequest.new(params[:registration_request])
    raise SecurityTransgression unless present_user.can_create?(@registration_request)

    respond_to do |format|
      if @registration_request.save
        notice_message = @registration_request.approved ?
                         'Your request has automatically been approved!' :
                         'Your request has been sent to the section ' + 
                           'educators. You will be emailed when the approve' + 
                           ' or reject your request.'
        format.html { redirect_to(@registration_request.section.klass, 
                                  :notice => notice_message ) }
      else
        format.html { redirect_to(@registration_request.section.klass,
                                  :alert => @registration_request.errors[:base].first) }
      end
    end
  end

  def approve
    @registration_request = RegistrationRequest.find(params[:id])
    raise SecurityTransgression unless @registration_request.can_be_approved_by?(present_user)

    @registration_request.approve!

    flash[:notice] = "Added #{@registration_request.user.full_name} to this section."
    respond_with(@registration_request)
  end

  def reject
    @registration_request = RegistrationRequest.find(params[:id])
    raise SecurityTransgression unless @registration_request.can_be_rejected_by?(present_user)

    @registration_request.reject!

    flash[:notice] = "Rejected #{@registration_request.user.full_name}'s request."
    respond_with(@registration_request)
  end

  def destroy
    @registration_request = RegistrationRequest.find(params[:id])
    raise SecurityTransgression unless present_user.can_destroy?(@registration_request)
    @registration_request.destroy

    respond_to do |format|
      format.html { redirect_to(@registration_request.section.klass) }
    end
  end

protected

  def get_klass
    @klass = Klass.find(params[:klass_id])
  end

  def teaching_assistant_and_up_required!
    @klass.is_teaching_assistant?(present_user)
  end
end
