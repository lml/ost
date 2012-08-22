class ScheduledNotificationMailer < SiteMailer
  
  def send!
    # Find the notifications that need to go out, and send them.  Group all
    # notifications to the same person with the same subject into one email
    
    ready_notifications = ScheduledNotification.where{send_after.lt Time.now}
    
    return if ready_notifications.empty?
    
    ready_notifications.all.group_by{|n| n.user}.each do |user, user_notifications|
      user_notifications.group_by{|un| un.subject}.each do |subject, user_subject_notifications|
        ScheduledNotificationMailer.standard_notification(user_subject_notifications).deliver
      end
    end
    
    ready_notifications.destroy_all
  end
  
  def standard_notification(notifications)
    # All notifications here share the same user and subject
    @user = notifications.first.user
    @subject = notifications.first.subject
    @notifications = notifications
    
    mail :to => "#{@user.full_name} <#{@user.email}>", :subject => @subject
  end

end
