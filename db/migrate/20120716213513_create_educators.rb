# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class CreateEducators < ActiveRecord::Migration
  def change
    create_table :educators do |t|
      t.integer :klass_id, :null => false
      t.integer :user_id, :null => false
      t.boolean :is_instructor
      t.boolean :is_teaching_assistant
      t.boolean :is_grader

      t.timestamps
    end
    
    add_index :educators, :klass_id
    add_index :educators, :user_id
  end
end
