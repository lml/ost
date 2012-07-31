class AddStudentSpecifiedIdToStudents < ActiveRecord::Migration
  def change
    add_column :students, :student_specified_id, :string, :limit => 30
  end
end
