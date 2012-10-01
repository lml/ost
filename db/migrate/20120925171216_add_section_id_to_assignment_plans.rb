class AddSectionIdToAssignmentPlans < ActiveRecord::Migration
  def change
    add_column :assignment_plans, :section_id, :integer
    add_index :assignment_plans, :section_id
  end
end
