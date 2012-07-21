class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.text :description
      t.string :typically_offered
      t.integer :organization_id, :null => false
      t.integer :number

      t.timestamps
    end
    
    add_index :courses, :organization_id
  end
end
