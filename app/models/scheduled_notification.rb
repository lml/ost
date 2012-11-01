# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class ScheduledNotification < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :message, :send_after, :subject, :user
  
  validates :send_after, :presence => true
end
