# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

ActionMailer::Base.add_delivery_method :ses, AWS::SES::Base,
  :access_key_id     => SECRET_SETTINGS[:aws_ses_access_key_id],
  :secret_access_key => SECRET_SETTINGS[:aws_ses_secret_access_key]