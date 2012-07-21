class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :resourceable_type, :null => false, :limit => 40
      t.integer :resourceable_id, :null => false
      t.string :url
      t.string :name
      t.text :notes
      t.integer :number

      t.timestamps
    end
    
    add_index :resources, [:resourceable_id, :resourceable_type]
  end
end
