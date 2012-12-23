# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :output, "log/whenever_cron.log"

every 5.minutes do
  runner "AssignmentPlan.build_and_distribute_assignments"
  runner "Assignment.create_missing_student_assignments"
end

every 30.minutes do
  runner "StudentAssignment.note_if_due!"
end

every 1.hour, :at => [10, 40] do
  runner "ScheduledNotificationMailer.send!"
end

