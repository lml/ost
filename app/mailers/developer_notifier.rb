# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class DeveloperNotifier < SiteMailer
  
  def exception_email(exception, user = nil, msg = nil, full_trace = false)
    @user = user
    @exception = exception
    @backtrace = full_trace ?
                 exception.backtrace :
                 Rails.backtrace_cleaner.clean(exception.backtrace)
    @msg = msg
    
    subject = user.nil? ? "An exception occurred" : user.username + " encountered an exception"

    mail(:to => User.active_administrators.collect { |a| a.email },
         :subject => subject).deliver(:safe_delivery_disabled => true)
  end

  def custom_email(msg)
    @msg = msg
    mail(:to => User.active_administrators.collect { |a| a.email },
         :subject => "Automated message from #{SITE_NAME}").deliver
  end

end
