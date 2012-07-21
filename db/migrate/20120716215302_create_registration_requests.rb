class CreateRegistrationRequests < ActiveRecord::Migration
  def change
    create_table :registration_requests do |t|
      t.integer :user_id, :null => false
      t.integer :section_id, :null => false
      t.boolean :is_auditing, :null => false

      t.timestamps
    end
    
    add_index :registration_requests, :user_id
    add_index :registration_requests, :section_id
  end
end
