class CreateFeedbackConditions < ActiveRecord::Migration
  def change
    create_table :feedback_conditions do |t|
      t.integer :learning_condition_id, :null => false
      t.text :settings
      t.string :type
      t.integer :number

      t.timestamps
    end
    
    add_index :feedback_conditions, :learning_condition_id
  end
end
