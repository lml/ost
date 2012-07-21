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
