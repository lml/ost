class CreateStudentAssignments < ActiveRecord::Migration
  def change
    create_table :student_assignments do |t|
      t.integer :student_id, :null => false
      t.integer :assignment_id, :null => false

      t.timestamps
    end
    
    add_index :student_assignments, :student_id
    add_index :student_assignments, :assignment_id
  end
end
