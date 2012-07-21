class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.integer :offered_course_id, :null => false
      t.string :name

      t.timestamps
    end
    
    add_index :sections, :offered_course_id
  end
end
