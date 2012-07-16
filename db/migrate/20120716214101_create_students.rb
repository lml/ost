class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.integer :cohort_id
      t.integer :user_id
      t.boolean :is_auditing

      t.timestamps
    end
  end
end
