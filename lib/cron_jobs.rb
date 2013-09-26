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
      Rails.logger.info "CRON: #{Time.now} begin 5 min cron jobs"

      Rails.logger.info "CRON: #{Time.now} begin AssignmentPlanbuild_and_distribute_assignments"
      AssignmentPlan.build_and_distribute_assignments
      Rails.logger.info "CRON: #{Time.now} end   AssignmentPlanbuild_and_distribute_assignments"

      Rails.logger.info "CRON: #{Time.now} begin create_missing_student_assignments"
      Assignment.create_missing_student_assignments
      Rails.logger.info "CRON: #{Time.now} end   create_missing_student_assignments"

      Rails.logger.info "CRON: #{Time.now} end   5 min cron jobs"
    end

    def execute_30min_cron_jobs
      Rails.logger.info "CRON: #{Time.now} begin 30 min cron jobs"

      Rails.logger.info "CRON: #{Time.now} begin StudentAssignment.note_if_due!"
      StudentAssignment.note_if_due!
      Rails.logger.info "CRON: #{Time.now} end   StudentAssignment.note_if_due!"

      Rails.logger.info "CRON: #{Time.now} begin MailHook.destroy_all_expired!"
      MailHook.destroy_all_expired!
      Rails.logger.info "CRON: #{Time.now} end   MainlHook.destroy_all_expired!"

      Rails.logger.info "CRON: #{Time.now} begin StudentExercise.update_page_view_info!"
      StudentExercise.update_page_view_info!
      Rails.logger.info "CRON: #{Time.now} end   StudentExercise.update_page_view_info!"

      Rails.logger.info "CRON: #{Time.now} end   30 min cron jobs"
    end

    def execute_60min_cron_jobs
      Rails.logger.info "CRON: #{Time.now} begin 60 min cron jobs"

      Rails.logger.info "CRON: #{Time.now} begin ScheduledNotificationMailer.send!"
      ScheduledNotificationMailer.send!
      Rails.logger.info "CRON: #{Time.now} end   ScheduledNotificationMailer.send!"

      Rails.logger.info "CRON: #{Time.now} end   60 min cron jobs"
    end

  end
end