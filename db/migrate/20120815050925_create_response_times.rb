class CreateResponseTimes < ActiveRecord::Migration
  def change
    create_table :response_times do |t|
      t.integer :response_timeable_id, :null => false
      t.string :response_timeable_type, :null => false, :limit => 40
      t.string :event
      t.string :note
      t.string :page

      t.timestamps
    end
    
    add_index :response_times, [:response_timeable_id, :response_timeable_type], :name => 'response_timeable_index'
  end
end
