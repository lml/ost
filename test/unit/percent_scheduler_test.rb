require 'test_helper'

class PercentSchedulerTest < ActiveSupport::TestCase

  def test_basic
    aps = [FactoryGirl.create(:assignment_plan, 
                              :starts_at => Time.now)]
    
    2.times do |n|
      aps.push FactoryGirl.create(:assignment_plan, 
                                  :starts_at => Time.now + (n+1).days)
    end
    
  end

end
