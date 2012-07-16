class AddIndexesToUsers < ActiveRecord::Migration
  def change
    add_index :users, :research_id, :unique => true
    add_index :users, :education_id, :unique => true
  end
end
