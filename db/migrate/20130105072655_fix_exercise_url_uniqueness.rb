class FixExerciseUrlUniqueness < ActiveRecord::Migration
  def up
    add_index     :exercises, :url, :unique => true, :name => "index_exercises_on_url"
  end

  def down
    remove_index  :exercises, :name => "index_exercises_on_url"
  end
end
