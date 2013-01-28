class RemoveContentTypeFromFreeResponses < ActiveRecord::Migration
  def change
    remove_column :free_responses, :content_type, :string
  end
end
