# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class SiteMailer < ActionMailer::Base
  include Ost::Utilities
    
  default :from => "noreply@openstaxtutor.org"

  def mail(headers={}, &block)
    headers[:subject] = "[OST] " + headers[:subject]
    super(headers, &block)
  end
end