class CreatePresentationConditions < ActiveRecord::Migration
  def change
    create_table :presentation_conditions do |t|
      t.integer :learning_condition_id, :null => false
      t.text :settings
      t.integer :number

      t.timestamps
    end
  end
end
