class AddEndDateToOfferedCourse < ActiveRecord::Migration
  def change
    add_column :offered_courses, :end_date, :datetime
  end
end
