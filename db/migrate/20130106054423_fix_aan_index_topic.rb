class FixAanIndexTopic < ActiveRecord::Migration
  def up
    add_index     :topics, [:number, :learning_plan_id], :unique => true, :name => "index_topics_on_number_scoped"
  end

  def down
    remove_index  :topics, :name => "index_topics_on_number_scoped"
  end
end
