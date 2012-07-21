class CreateResearchers < ActiveRecord::Migration
  def change
    create_table :researchers do |t|
      t.integer :user_id, :null => false

      t.timestamps
    end
    
    add_index :researchers, :user_id, :unique => true
  end
end
