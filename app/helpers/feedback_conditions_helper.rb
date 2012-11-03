# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

module FeedbackConditionsHelper

  def feedback_condition_name(feedback_condition)
    case feedback_condition.type
    when 'BasicFeedbackCondition'
      'Basic'
    else
      raise IllegalArgument
    end      
  end

end
