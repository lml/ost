# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.


module Ost
  module Cron

    ##
    ## NOTE: Changes here should also be reflected in:
    ##   config/schedules.rb
    ##   app/controllers/dev_controller.rb (and related views)
    ##

    def execute_cron_jobs
      execute_5min_cron_jobs
      execute_30min_cron_jobs
      execute_60min_cron_jobs
    end

    def execute_5min_cron_jobs
      AssignmentPlan.build_and_distribute_assignments
      Assignment.create_missing_student_assignments
    end

    def execute_30min_cron_jobs
      StudentAssignment.note_if_due!
      MailHook.destroy_all_expired!
    end

    def execute_60min_cron_jobs
      ScheduledNotificationMailer.send!
    end

  end  
end