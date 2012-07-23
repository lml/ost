class AddTimeZoneToUser < ActiveRecord::Migration
  def change
    add_column :users, :time_zone, :string, :null => false, :limit => 40, :default => "Central Time (US & Canada)"
  end
end
