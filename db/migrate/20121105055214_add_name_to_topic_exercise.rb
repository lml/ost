class AddNameToTopicExercise < ActiveRecord::Migration
  def change
    add_column :topic_exercises, :name, :string
  end
end
