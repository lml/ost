class AddHideFreeResponseToTopicExercises < ActiveRecord::Migration
  def change
    add_column :topic_exercises, :hide_free_response, :boolean, default: false, nil: false
  end
end
