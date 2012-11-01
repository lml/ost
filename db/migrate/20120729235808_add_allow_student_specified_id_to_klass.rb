# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class AddAllowStudentSpecifiedIdToKlass < ActiveRecord::Migration
  def change
    add_column :klasses, :allow_student_specified_id, :boolean, :default => false, :null => false
  end
end
