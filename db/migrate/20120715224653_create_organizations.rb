class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :default_time_zone

      t.timestamps
    end
  end
end
