# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class AddStudentSpecifiedIdToRegistrationRequests < ActiveRecord::Migration
  def change
    add_column :registration_requests, :student_specified_id, :string, :limit => 30
  end
end
