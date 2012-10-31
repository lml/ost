# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class AddSectionIdToAssignmentPlans < ActiveRecord::Migration
  def change
    add_column :assignment_plans, :section_id, :integer
    add_index :assignment_plans, :section_id
  end
end
