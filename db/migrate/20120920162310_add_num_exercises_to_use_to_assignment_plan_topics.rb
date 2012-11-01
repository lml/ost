# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class AddNumExercisesToUseToAssignmentPlanTopics < ActiveRecord::Migration
  def change
    add_column :assignment_plan_topics, :num_exercises_to_use, :integer
  end
end
