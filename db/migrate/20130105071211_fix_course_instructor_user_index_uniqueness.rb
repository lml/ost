class FixCourseInstructorUserIndexUniqueness < ActiveRecord::Migration
  def up
    add_index     :course_instructors, [:user_id, :course_id], :unique => true, :name => "index_course_instructor_on_user_id_scoped"
  end

  def down
    remove_index  :course_instructors, :name => "index_course_instructor_on_user_id_scoped"
  end
end
