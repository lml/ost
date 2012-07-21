class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.integer :cohort_id, :null => false
      t.integer :user_id, :null => false
      t.boolean :is_auditing

      t.timestamps
    end
    
    add_index :students, :cohort_id
    add_index :students, :user_id
  end
end
