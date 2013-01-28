class FixCourseNameIndexUniqueness < ActiveRecord::Migration
  def up
    add_index     :courses, [:name, :organization_id], :unique => true, :name => "index_courses_on_name_scoped"
  end

  def down
    remove_index  :courses, :name => "index_courses_on_name_scoped"
  end
end
