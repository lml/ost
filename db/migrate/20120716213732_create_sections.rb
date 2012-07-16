class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.integer :offered_course_id
      t.string :name

      t.timestamps
    end
  end
end
