# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class CreateAssignmentTopics < ActiveRecord::Migration
  def change
    create_table :assignment_topics do |t|
      t.integer :assignment_id, :null => false
      t.integer :topic_id, :null => false

      t.timestamps
    end
    
    add_index :assignment_topics, :assignment_id
    add_index :assignment_topics, :topic_id
  end
end
