class Resource < ActiveRecord::Base
  belongs_to :topic
  
  validates :topic_id, :presence => true
  validate :enough_content
  
  acts_as_numberable :container => :topic
  
  attr_accessible :name, :notes, :url
  
protected

  def enough_content
    return if !url.blank?
  end

end
