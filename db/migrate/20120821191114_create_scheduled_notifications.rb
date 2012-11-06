# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class CreateScheduledNotifications < ActiveRecord::Migration
  def change
    create_table :scheduled_notifications do |t|
      t.integer :user_id
      t.string :subject
      t.text :message
      t.datetime :send_after

      t.timestamps
    end
    
    add_index :scheduled_notifications, :user_id
  end
end
