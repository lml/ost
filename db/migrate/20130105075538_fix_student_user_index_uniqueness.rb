class FixStudentUserIndexUniqueness < ActiveRecord::Migration
  def up
    add_index     :students, [:user_id, :cohort_id], :unique => true, :name => "index_students_on_user_id_scoped"
  end

  def down
    remove_index  :students, :name => "index_students_on_user_id_scoped"
  end
end
