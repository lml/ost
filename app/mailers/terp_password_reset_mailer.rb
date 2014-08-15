# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class TerpPasswordResetMailer < SiteMailer
  helper :application
  
  def reset(user)
    @user = user
    mail :to => user.email,
         :subject => "Your password reset code"
  end
end
