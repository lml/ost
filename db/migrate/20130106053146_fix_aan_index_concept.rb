class FixAanIndexConcept < ActiveRecord::Migration
  def up
    add_index     :concepts, [:number, :learning_plan_id], :unique => true, :name => "index_concepts_on_number_scoped"
  end

  def down
    remove_index  :concepts, :name => "index_concepts_on_number_scoped"
  end
end
