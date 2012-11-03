# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class CreateFeedbackConditions < ActiveRecord::Migration
  def change
    create_table :feedback_conditions do |t|
      t.integer :learning_condition_id, :null => false
      t.text :settings
      t.string :type
      t.integer :number

      t.timestamps
    end
    
    add_index :feedback_conditions, :learning_condition_id
  end
end
