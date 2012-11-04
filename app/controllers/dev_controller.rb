# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

require 'chronic'

class DevController < ApplicationController
  skip_before_filter :authenticate_user!
  before_filter :check_dev_env
  before_filter :include_timepicker

  def toolbox
  end

  def reset_time
    Timecop.return
  end

  def time_travel
    Timecop.return
    new_time_in_zone = TimeUtils.timestr_and_zonestr_to_utc_time(params[:new_time], params[:time_zone])
    Timecop.travel(new_time_in_zone)
  end
  
  def freeze_time
    Timecop.return
    Timecop.freeze(params[:offset_days].to_i.days.since(Time.now))
  end
  
  def test_error
    render :template => "errors/#{params[:number]}"
  end
  
protected

  def check_dev_env
    raise SecurityTransgression if Rails.env.production?
  end

end
