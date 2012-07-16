class CreateOfferedCourses < ActiveRecord::Migration
  def change
    create_table :offered_courses do |t|
      t.integer :course_id
      t.text :approved_emails
      t.integer :consent_form_id
      t.datetime :start_date

      t.timestamps
    end
    
    add_index :offered_courses, :course_id
    add_index :offered_courses, :consent_form_id
  end
end
