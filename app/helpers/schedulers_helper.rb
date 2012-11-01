# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

module SchedulersHelper
  
  def scheduler_name(scheduler)
    case scheduler.type
    when 'PercentScheduler'
      'Percentage'
    else
      raise IllegalArgument
    end      
  end
  
end
