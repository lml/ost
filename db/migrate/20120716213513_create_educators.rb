class CreateEducators < ActiveRecord::Migration
  def change
    create_table :educators do |t|
      t.integer :offered_course_id, :null => false
      t.integer :user_id, :null => false
      t.boolean :is_instructor
      t.boolean :is_teaching_assistant
      t.boolean :is_grader

      t.timestamps
    end
    
    add_index :educators, :offered_course_id
    add_index :educators, :user_id
  end
end
