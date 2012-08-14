class AddReservedForTestsToTopicExercises < ActiveRecord::Migration
  def change
    add_column :topic_exercises, :reserved_for_tests, :boolean, :default => false
  end
end
