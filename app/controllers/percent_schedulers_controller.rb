# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.


class PercentSchedulersController < ApplicationController

  before_filter :get_scheduler

  def add_schedule
    raise SecurityTransgression unless present_user.can_update?(@scheduler)
    @schedule = @scheduler.add_schedule
    @number = @scheduler.schedules.size-1
    @scheduler.save
  end
  
  def add_schedule_row
    raise SecurityTransgression unless present_user.can_update?(@scheduler)
    @schedule_number = params[:number].to_i
    @schedule_row, @schedule_size = @scheduler.add_schedule_row(@schedule_number)
    @scheduler.save
  end
  
  def pop_schedule_row
    raise SecurityTransgression unless present_user.can_update?(@scheduler)
    @schedule_number = params[:schedule_number].to_i
    @scheduler.pop_schedule_row(@schedule_number)
    @scheduler.save
  end
  
protected

  def get_scheduler
    @scheduler = Scheduler.find(params[:percent_scheduler_id])
  end

end
