class AddHideResourcesToAssignmentPlanTopics < ActiveRecord::Migration
  def change
    add_column :assignment_plan_topics, :hide_resources, :boolean, :default => false
  end
end
