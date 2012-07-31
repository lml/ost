class AddAllowStudentSpecifiedIdToKlass < ActiveRecord::Migration
  def change
    add_column :klasses, :allow_student_specified_id, :boolean, :default => false, :null => false
  end
end
