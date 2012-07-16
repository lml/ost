class CreateResearchers < ActiveRecord::Migration
  def change
    create_table :researchers do |t|
      t.integer :user_id

      t.timestamps
    end
    
    add_index :researchers, :user_id
  end
end
