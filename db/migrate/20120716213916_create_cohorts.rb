class CreateCohorts < ActiveRecord::Migration
  def change
    create_table :cohorts do |t|
      t.integer :section_id, :null => false
      t.integer :number

      t.timestamps
    end
    
    add_index :cohorts, :section_id
  end
end
