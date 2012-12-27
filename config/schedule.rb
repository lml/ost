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

##
## NOTE: Changes here should also be reflected in:
##  lib/cron_jobs.rb
##  app/controllers/dev_controller.rb (and related views)
##

every 5.minutes do
  runner "Ost::Cron.execute_5min_cron_jobs"
end

every 30.minutes do
  runner "Ost::Cron.execute_30min_cron_jobs"
end

every 1.hour, :at => [10, 40] do
  runner "Ost::Cron.execute_60min_cron_jobs"
end

