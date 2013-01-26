
class FileFreeResponse < FreeResponse

  validates :attachment, :presence => true

  before_create :set_attachment_content_type

protected

  def set_attachment_content_type
    self.attachment_content_type = attachment.file.content_type
  end

end