# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class CreateResearchers < ActiveRecord::Migration
  def change
    create_table :researchers do |t|
      t.integer :user_id, :null => false

      t.timestamps
    end
    
    add_index :researchers, :user_id, :unique => true
  end
end
