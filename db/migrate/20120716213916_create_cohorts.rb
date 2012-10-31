# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class CreateCohorts < ActiveRecord::Migration
  def change
    create_table :cohorts do |t|
      t.integer :section_id, :null => false
      t.integer :number

      t.timestamps
    end
    
    add_index :cohorts, :section_id
  end
end
