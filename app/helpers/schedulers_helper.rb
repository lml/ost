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
