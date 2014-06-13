# Copyright 2011-2014 Rice University. Licensed under the Affero General Public
# License version 3 or later.  See the COPYRIGHT file for details.

class AddUserSettings < ActiveRecord::Migration
  def change
    create_table(:user_settings) do |t|
      t.integer :user_id, :null => false
      t.text    :settings, :null => true
      t.timestamps
    end

    add_index :user_settings, :user_id
  end
end
