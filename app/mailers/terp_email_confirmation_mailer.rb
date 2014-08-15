# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class TerpEmailConfirmationMailer < SiteMailer
  helper :application
  
  def code(user)
    @user = user
    mail :to => user.email,
         :subject => "Please confirm your email address"
  end
end
