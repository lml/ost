class FixResourceUrlUniqueness < ActiveRecord::Migration
  def up
    add_index     :resources, [:url, :topic_id], :unique => true, :name => "index_resources_on_url_scoped"
  end

  def down
    remove_index  :resources, :name => "index_resources_on_url_scoped"
  end
end
