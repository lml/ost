class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.integer :topic_id, :null => false
      t.string :url
      t.string :name
      t.text :notes
      t.integer :number

      t.timestamps
    end
    
    add_index :resources, :topic_id
  end
end
