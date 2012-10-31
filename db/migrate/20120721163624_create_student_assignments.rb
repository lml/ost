# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class CreateStudentAssignments < ActiveRecord::Migration
  def change
    create_table :student_assignments do |t|
      t.integer :student_id, :null => false
      t.integer :assignment_id, :null => false

      t.timestamps
    end
    
    add_index :student_assignments, :student_id
    add_index :student_assignments, :assignment_id
  end
end
