class CreateLearningPlans < ActiveRecord::Migration
  def change
    create_table :learning_plans do |t|
      t.integer :learning_plannable_id, :null => false
      t.string :learning_plannable_type, :null => false, :limit => 40
      t.string :name
      t.text :description

      t.timestamps
    end
    
    add_index :learning_plans, [:learning_plannable_id, :learning_plannable_type], :name => 'learning_plannable_index'
  end
end