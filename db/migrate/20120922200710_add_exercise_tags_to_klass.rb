class AddExerciseTagsToKlass < ActiveRecord::Migration
  def change
    add_column :klasses, :test_exercise_tags, :string
    add_column :klasses, :nontest_exercise_tags, :string
  end
end
