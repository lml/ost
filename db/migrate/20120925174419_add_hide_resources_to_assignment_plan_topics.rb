# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class AddHideResourcesToAssignmentPlanTopics < ActiveRecord::Migration
  def change
    add_column :assignment_plan_topics, :hide_resources, :boolean, :default => false
  end
end
