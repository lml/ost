# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class ResponseTimesController < ApplicationController

  def create
    @response_time = ResponseTime.new(params[:response_time])    
    
    raise SecurityTransgression unless present_user.can_create?(@response_time)
    if !@response_time.save
      logger.warn("Response time not saved! #{@response_time.errors.inspect}")
    end
    
    respond_to do |type| 
      type.all  { render :nothing => true, :status => status } 
    end
  end


end
