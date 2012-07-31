class AddStudentSpecifiedIdToRegistrationRequests < ActiveRecord::Migration
  def change
    add_column :registration_requests, :student_specified_id, :string, :limit => 30
  end
end
