# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class SetFeedbackDefaultsToBasicFeedbackCondition < ActiveRecord::Migration
  def up
    BasicFeedbackCondition.all.each do |bfc|
      bfc.show_correctness_feedback    = true
      bfc.show_correct_answer_feedback = true
      bfc.show_high_level_feedback     = true
      bfc.show_detailed_feedback       = true
      bfc.save!
    end
  end

  def down
    BasicFeedbackCondition.all.each do |bfc|
      bfc.show_correctness_feedback    = nil
      bfc.show_correct_answer_feedback = nil
      bfc.show_high_level_feedback     = nil
      bfc.show_detailed_feedback       = nil
      bfc.save!
    end
  end
end
