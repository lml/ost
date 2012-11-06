# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class CreateResponseTimes < ActiveRecord::Migration
  def change
    create_table :response_times do |t|
      t.integer :response_timeable_id, :null => false
      t.string :response_timeable_type, :null => false, :limit => 40
      t.string :event
      t.string :note
      t.string :page

      t.timestamps
    end
    
    add_index :response_times, [:response_timeable_id, :response_timeable_type], :name => 'response_timeable_index'
  end
end
