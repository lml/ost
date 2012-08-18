class CreateSiteLicenses < ActiveRecord::Migration
  def change
    create_table :site_licenses do |t|
      t.text :title
      t.text :body
      
      t.timestamps
    end
  end
end
