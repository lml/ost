class AddShortNameToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :short_name, :string
  end
end
