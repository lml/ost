class ScheduledNotificationMailer < SiteMailer

  def schedule_basic_feedback_condition(basic_feedback_condition, student_exercise, feedback_opens_at, feedback_closes_at)
    @basic_feedback_condition = basic_feedback_condition
    @student_exercise = student_exercise
    @feedback_closes_at = feedback_closes_at

    message = feedback_availability_message(self, student_exercise, feedback_closes_at)

     ScheduledNotification.create(:user => student_exercise.student.user,
                                  :send_after => feedback_opens_at,
                                  :subject => student_exercise.course.short_name + " feedback available",
                                  :message => message)
  end
  
  def send!
    
  end

end
