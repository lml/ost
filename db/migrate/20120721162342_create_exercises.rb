class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.string :url
      t.boolean :is_dynamic
      t.text :content_cache

      t.timestamps
    end
  end
end
