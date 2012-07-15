class CreateWebsiteConfigurations < ActiveRecord::Migration
  def change
    create_table(:website_configurations) do |t|
      t.string :name
      t.string :value
      t.string :value_type

      t.timestamps
    end
  end
end
