class RemoveGlobalLabelsFromKlass < ActiveRecord::Migration
  def up
    remove_column :klasses, :test_exercise_tags
    remove_column :klasses, :nontest_exercise_tags
  end

  def down
    add_column :klasses, :nontest_exercise_tags,  :string, :default => ""
    add_column :klasses, :test_exercise_tags,     :string, :default => ""
  end
end
