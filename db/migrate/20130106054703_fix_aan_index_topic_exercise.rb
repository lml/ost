class FixAanIndexTopicExercise < ActiveRecord::Migration
  def up
    add_index     :topic_exercises, [:number, :topic_id], :unique => true, :name => "index_topic_exercises_on_number_scoped"
  end

  def down
    remove_index  :topic_exercises, :name => "index_topic_exercises_on_number_scoped"
  end
end
