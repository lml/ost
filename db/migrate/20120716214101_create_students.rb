# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.integer :cohort_id
      t.integer :section_id, :null => false
      t.integer :user_id, :null => false
      t.boolean :is_auditing

      t.timestamps
    end
    
    add_index :students, :cohort_id
    add_index :students, :section_id
    add_index :students, :user_id
  end
end
