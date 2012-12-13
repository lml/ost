# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.


module Ost
  module Cron

  def execute_cron_jobs
    AssignmentPlan.build_and_distribute_assignments
    Assignment.create_missing_student_assignments
    StudentAssignment.note_if_due!
    ScheduledNotificationMailer.send!
  end
  
end
  
end