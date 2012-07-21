class CreateCourseInstructors < ActiveRecord::Migration
  def change
    create_table :course_instructors do |t|
      t.integer :course_id, :null => false
      t.integer :user_id, :null => false

      t.timestamps
    end
    
    add_index :course_instructors, :course_id
    add_index :course_instructors, :user_id
  end
end
