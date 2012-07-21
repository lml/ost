class RegistrationRequestObserver < ActiveRecord::Observer
  
  def approved(registration_request)
    RegistrationRequestMailer.approved(registration_request).deliver
  end
  
  def rejected(registration_request)
    RegistrationRequestMailer.rejected(registration_request).deliver
  end
  
  def after_create(registration_request)
    RegistrationRequestMailer.created(registration_request).deliver if !registration_request.destroyed
  end
  
end
