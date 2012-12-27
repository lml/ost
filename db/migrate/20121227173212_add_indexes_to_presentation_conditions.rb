class AddIndexesToPresentationConditions < ActiveRecord::Migration
  def change
    add_index :presentation_conditions, :learning_condition_id
  end
end
