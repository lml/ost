class FixAanIndexResource < ActiveRecord::Migration
  def up
    add_index     :resources, [:number, :topic_id], :unique => true, :name => "index_resources_on_number_scoped"
  end

  def down
    remove_index  :resources, :name => "index_resources_on_number_scoped"
  end
end
