class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :learning_plan_id, :null => false
      t.string :name, :limit => 100
      t.boolean :is_test
      t.boolean :is_open_book
      t.boolean :is_group_work_allowed
      t.boolean :is_ready
      t.text :introduction
      t.datetime :starts_at
      t.datetime :ends_at
      t.float :grade_weight

      t.timestamps
    end
    
    add_index :assignments, :learning_plan_id
  end
end
