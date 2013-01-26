class AddAttachmentContentTypeToFreeResponses < ActiveRecord::Migration
  def change
    add_column :free_responses, :attachment_content_type, :string
  end
end
