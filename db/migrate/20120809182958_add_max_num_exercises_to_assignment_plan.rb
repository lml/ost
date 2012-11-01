# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class AddMaxNumExercisesToAssignmentPlan < ActiveRecord::Migration
  def change
    add_column :assignment_plans, :max_num_exercises, :integer
  end
end
