# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class CreateAssignmentCoworkers < ActiveRecord::Migration
  def change
    create_table :assignment_coworkers do |t|
      t.integer :student_assignment_id
      t.integer :student_id

      t.timestamps
    end
    
    add_index :assignment_coworkers, :student_assignment_id
    add_index :assignment_coworkers, :student_id
  end
end
