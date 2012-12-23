# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class SetDefaultPresentationConditions < ActiveRecord::Migration
  def up
    LearningCondition.find_each do |lc|
      lc.presentation_conditions << PresentationCondition.default_presentation_condition
      lc.save!
    end
  end

  def down
    PresentationCondition.find_each do |pc|
      pc.destroy
    end
  end
end
