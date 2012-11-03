# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class CreateConcepts < ActiveRecord::Migration
  def change
    create_table :concepts do |t|
      t.string :name
      t.integer :learning_plan_id, :null => false
      t.integer :number

      t.timestamps
    end
    
    add_index :concepts, :learning_plan_id
  end
end
