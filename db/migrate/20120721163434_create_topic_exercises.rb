class CreateTopicExercises < ActiveRecord::Migration
  def change
    create_table :topic_exercises do |t|
      t.integer :topic_id, :null => false
      t.integer :exercise_id, :null => false
      t.integer :concept_id
      t.integer :number

      t.timestamps
    end
    
    add_index :topic_exercises, :topic_id
    add_index :topic_exercises, :exercise_id
    add_index :topic_exercises, :concept_id
  end
end
