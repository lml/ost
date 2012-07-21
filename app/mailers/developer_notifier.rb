# Copyright (c) 2011 Rice University.  All rights reserved.

class DeveloperNotifier < SiteMailer
  
  def exception_email(exception, user, full_trace = false)
    @user = user
    @exception = exception
    @backtrace = full_trace ?
                 exception.backtrace :
                 Rails.backtrace_cleaner.clean(exception.backtrace)

    mail(:to => User.active_administrators.collect { |a| a.email },
         :subject => user.username + " encountered an exception").deliver
  end

  def custom_email(msg)
    @msg = msg
    mail(:to => User.active_administrators.collect { |a| a.email },
         :subject => "Automated message from #{SITE_NAME}").deliver
  end

end
