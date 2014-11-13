# Copyright 2011-2014 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class TerpMailer < ActionMailer::Base
  include Ost::Utilities
  
  helper :application

  default :from => "noreply@openstaxtutor.org"

  def mail(headers={}, &block)
    headers[:subject] = "[Concept Coach] " + headers[:subject]
    super(headers, &block)
  end
end
