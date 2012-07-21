class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :name, :limit => 100
      t.integer :learning_plan_id, :null => false
      t.integer :number

      t.timestamps
    end
    
    add_index :topics, :learning_plan_id
  end
end
