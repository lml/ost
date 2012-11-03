# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class AddCompletedAtToStudentAssignments < ActiveRecord::Migration
  def change
    add_column :student_assignments, :completed_at, :datetime
  end
end
