class FixTopicNameUniqueness < ActiveRecord::Migration
  def up
    add_index     :topics, [:name, :learning_plan_id], :unique => true, :name => "index_topics_on_name_scoped"
  end

  def down
    remove_index  :topics, :name => "index_topics_on_name_scoped"
  end
end
