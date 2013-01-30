class CreateFreeResponses < ActiveRecord::Migration
  def change
    create_table :free_responses do |t|
      t.integer :student_exercise_id
      t.string :attachment
      t.text :content
      t.string :content_type

      t.timestamps
    end
  end
end
