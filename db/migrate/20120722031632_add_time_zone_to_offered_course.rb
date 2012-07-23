class AddTimeZoneToOfferedCourse < ActiveRecord::Migration
  def change
    add_column :offered_courses, :time_zone, :string
  end
end
