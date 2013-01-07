class FixAanIndexPresentationCondition < ActiveRecord::Migration
  def up
    add_index     :presentation_conditions, [:number, :learning_condition_id], :unique => true, :name => "index_presentation_condition_on_number_scoped"
  end

  def down
    remove_index  :presentation_conditions, :name => "index_presentation_condition_on_number_scoped"
  end
end
