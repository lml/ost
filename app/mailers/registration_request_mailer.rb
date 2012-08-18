class RegistrationRequestMailer < SiteMailer
  helper :application
  
  def approved(registration_request)
    @registration_request = registration_request
    mail :to => registration_request.user.email,
         :subject => "You have been accepted into #{full_class_name(registration_request)}"
  end

  def rejected(registration_request)
    @registration_request = registration_request
    mail :to => registration_request.user.email,
         :subject => "You have been rejected from #{full_class_name(registration_request)}"
  end
  
  def created(registration_request)
    @registration_request = registration_request
    mail :to => registration_request.section.klass.educators.collect{|e| e.user.email},
         :subject => "#{registration_request.requestor_full_name} wants to join #{full_class_name(registration_request)}"
  end
end
