class FixConceptNameIndexUniqueness < ActiveRecord::Migration
  def up
    add_index     :concepts, [:name, :learning_plan_id], :unique => true, :name => "index_concepts_on_name_scoped"
  end

  def down
    remove_index  :concepts, :name => "index_concepts_on_name_scoped"
  end
end
