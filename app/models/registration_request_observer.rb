# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

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
