# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class SetFeedbackConditionDefaults < ActiveRecord::Migration
  def up
    FeedbackCondition.all.each do |fc|
      fc.show_correctness_feedback    = true
      fc.show_correct_answer_feedback = true
      fc.show_high_level_feedback     = true
      fc.show_detailed_feedback       = true
      fc.save!
    end
  end

  def down
    FeedbackCondition.all.each do |fc|
      fc.show_correctness_feedback    = nil
      fc.show_correct_answer_feedback = nil
      fc.show_high_level_feedback     = nil
      fc.show_detailed_feedback       = nil
      fc.save!
    end
  end
end
