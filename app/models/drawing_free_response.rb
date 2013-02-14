
class DrawingFreeResponse < FreeResponse

  validates :content, :presence => true

  def as_text
    "[Drawing]"
  end
end