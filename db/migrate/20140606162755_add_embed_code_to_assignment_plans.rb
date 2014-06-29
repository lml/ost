class AddEmbedCodeToAssignmentPlans < ActiveRecord::Migration
  def change
    add_column :assignment_plans, :embed_code, :string
    add_index :assignment_plans, :embed_code
  end
end
