
module Ost
  module Cron

  def execute_cron_jobs
    AssignmentPlan.build_and_distribute_assignments
    StudentAssignment.note_if_due!
    ScheduledNotificationMailer.send!
  end
  
end
  
end