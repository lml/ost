
class FileFreeResponse < FreeResponse

  validates :attachment, :presence => true

  before_create :set_attachment_content_type

  def is_image?
    attachment_content_type.starts_with?("image")
  end

  def as_text 
    ["[File: #{read_attribute(:attachment)}]", content].compact.join(" ")
  end

protected

  def set_attachment_content_type
    self.attachment_content_type = attachment.file.content_type
  end

end