# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class AddObservedDueAtToStudentAssignments < ActiveRecord::Migration
  def change
    add_column :student_assignments, :observed_due_at, :datetime
  end
end
