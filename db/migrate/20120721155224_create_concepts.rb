class CreateConcepts < ActiveRecord::Migration
  def change
    create_table :concepts do |t|
      t.string :name
      t.integer :learning_plan_id, :null => false
      t.integer :number

      t.timestamps
    end
    
    add_index :concepts, :learning_plan_id
  end
end
