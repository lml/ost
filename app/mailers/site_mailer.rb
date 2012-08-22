# Copyright (c) 2011 Rice University.  All rights reserved.

class SiteMailer < ActionMailer::Base
  include Ost::Utilities
    
  default :from => "noreply@openstaxtutor.org"

  def mail(headers={}, &block)
    headers[:subject] = "[OST] " + headers[:subject]
    super(headers, &block)
  end
end