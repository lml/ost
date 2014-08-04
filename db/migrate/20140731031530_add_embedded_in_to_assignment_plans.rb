class AddEmbeddedInToAssignmentPlans < ActiveRecord::Migration
  def change
    add_column :assignment_plans, :embedded_in, :string
  end
end
