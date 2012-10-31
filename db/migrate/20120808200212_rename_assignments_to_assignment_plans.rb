# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class RenameAssignmentsToAssignmentPlans < ActiveRecord::Migration
  def up
    rename_table :assignments, :assignment_plans
    
    remove_index :assignment_topics, :assignment_id
    remove_index :assignment_topics, :topic_id
    
    rename_table :assignment_topics, :assignment_plan_topics
    
    rename_column :assignment_plan_topics, :assignment_id, :assignment_plan_id
    
    add_index :assignment_plan_topics, :topic_id
    add_index :assignment_plan_topics, :assignment_plan_id
  end

  def down
    raise NotYetImplemented
  end
end
