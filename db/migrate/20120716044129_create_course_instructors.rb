class CreateCourseInstructors < ActiveRecord::Migration
  def change
    create_table :course_instructors do |t|
      t.integer :course_id
      t.integer :user_id

      t.timestamps
    end
    
    add_index :course_instructors, :course_id
    add_index :course_instructors, :user_id
  end
end
