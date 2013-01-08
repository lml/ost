class FixAanIndexCourse < ActiveRecord::Migration
  def up
    add_index     :courses, [:number, :organization_id], :unique => true, :name => "index_courses_on_number_scoped"
  end

  def down
    remove_index  :courses, :name => "index_courses_on_number_scoped"
  end
end
