# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :assignment_plan_id
      t.integer :cohort_id

      t.timestamps
    end
    
    add_index :assignments, :assignment_plan_id
    add_index :assignments, :cohort_id
  end
end
