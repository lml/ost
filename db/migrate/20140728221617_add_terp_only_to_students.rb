class AddTerpOnlyToStudents < ActiveRecord::Migration
  def change
    add_column :students, :terp_only, :boolean, default: false, null: false
  end
end
