# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.integer :topic_id, :null => false
      t.string :url
      t.string :name
      t.text :notes
      t.integer :number

      t.timestamps
    end
    
    add_index :resources, :topic_id
  end
end
