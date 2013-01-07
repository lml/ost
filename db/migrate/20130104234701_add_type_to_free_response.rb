class AddTypeToFreeResponse < ActiveRecord::Migration
  def change
    add_column :free_responses, :type, :string
  end
end
