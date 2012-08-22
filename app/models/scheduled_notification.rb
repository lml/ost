class ScheduledNotification < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :message, :send_after, :subject, :user
  
  validates :send_after, :presence => true
end
