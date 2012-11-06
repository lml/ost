# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.integer :klass_id, :null => false
      t.string :name

      t.timestamps
    end
    
    add_index :sections, :klass_id
  end
end
