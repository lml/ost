# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class CreateStudentExercises < ActiveRecord::Migration
  def change
    create_table :student_exercises do |t|
      t.integer :student_assignment_id, :null => false
      t.integer :assignment_exercise_id, :null => false
      t.text :content_cache
      t.text :free_response
      t.datetime :free_response_submitted_at
      t.integer :free_response_confidence
      t.integer :selected_answer
      t.datetime :selected_answer_submitted_at
      t.boolean :was_submitted_late
      t.float :automated_credit
      t.float :manual_credit

      t.timestamps
    end
    
    add_index :student_exercises, :student_assignment_id
    add_index :student_exercises, :assignment_exercise_id
  end
end
