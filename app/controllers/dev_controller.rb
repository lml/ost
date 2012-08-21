require 'chronic'

class DevController < ApplicationController
  skip_before_filter :authenticate_user!
  before_filter :check_dev_env

  def toolbox
  end

  def reset_time
    Timecop.return
  end

  def time_travel
    Timecop.return
    Timecop.travel(Chronic.parse(params[:new_time]))
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
    raise SecurityTransgression unless Rails.env.development?
  end

end
