# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class AddExerciseTagsToAssignmentPlans < ActiveRecord::Migration
  def change
    add_column :assignment_plans, :exercise_tags, :string
  end
end
