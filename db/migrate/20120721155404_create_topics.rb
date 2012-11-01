# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :name, :limit => 100
      t.integer :learning_plan_id, :null => false
      t.integer :number

      t.timestamps
    end
    
    add_index :topics, :learning_plan_id
  end
end
