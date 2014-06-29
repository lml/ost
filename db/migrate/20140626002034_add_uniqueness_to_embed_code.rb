class AddUniquenessToEmbedCode < ActiveRecord::Migration
  def change
    add_index :assignment_plans, [:embed_code, :learning_plan_id], :unique => true
  end
end
