# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class CreateOrganizationManagers < ActiveRecord::Migration
  def change
    create_table :organization_managers do |t|
      t.integer :organization_id, :null => false
      t.integer :user_id, :null => false

      t.timestamps
    end
    
    add_index :organization_managers, :organization_id
    add_index :organization_managers, :user_id
  end
end
