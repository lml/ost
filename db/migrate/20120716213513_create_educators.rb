class CreateEducators < ActiveRecord::Migration
  def change
    create_table :educators do |t|
      t.integer :offered_course_id
      t.integer :user_id
      t.boolean :is_instructor
      t.boolean :is_teaching_assistant
      t.boolean :is_grader

      t.timestamps
    end
  end
end
