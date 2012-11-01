# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class CreateAssignmentExercises < ActiveRecord::Migration
  def change
    create_table :assignment_exercises do |t|
      t.integer :assignment_id, :null => false
      t.integer :topic_exercise_id, :null => false
      t.integer :number

      t.timestamps
    end
    
    add_index :assignment_exercises, :assignment_id
    add_index :assignment_exercises, :topic_exercise_id
  end
end
