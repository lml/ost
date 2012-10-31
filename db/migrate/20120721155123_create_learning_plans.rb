# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class CreateLearningPlans < ActiveRecord::Migration
  def change
    create_table :learning_plans do |t|
      t.integer :learning_plannable_id, :null => false
      t.string :learning_plannable_type, :null => false, :limit => 40
      t.string :name
      t.text :description

      t.timestamps
    end
    
    add_index :learning_plans, [:learning_plannable_id, :learning_plannable_type], :name => 'learning_plannable_index'
  end
end