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
