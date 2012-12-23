# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class CreatePresentationConditions < ActiveRecord::Migration
  def change
    create_table :presentation_conditions do |t|
      t.integer :learning_condition_id, :null => false
      t.text :settings
      t.integer :number

      t.timestamps
    end
  end
end
