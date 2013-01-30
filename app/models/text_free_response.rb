
class TextFreeResponse < FreeResponse

  validates :content, :presence => true

  def as_text
    content
  end
end