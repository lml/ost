class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.integer :klass_id, :null => false
      t.string :name

      t.timestamps
    end
    
    add_index :sections, :klass_id
  end
end
