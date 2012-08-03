class Resource < ActiveRecord::Base
  belongs_to :topic
  
  validates :topic_id, :presence => true
  # validate :enough_content
  validates :url, :presence => true,
                  :uniqueness => {:scope => :topic_id},
                  :url_format => true,
                  :url_existence => true
  
  acts_as_numberable :container => :topic
  
  attr_accessible :name, :notes, :url
  
  #############################################################################
  # Access control methods
  #############################################################################

  def can_be_read_by?(user)
    topic.can_be_read_by?(user)
  end
    
  def can_be_created_by?(user)
    topic.can_be_updated_by?(user)
  end
  
  def can_be_updated_by?(user)
    topic.can_be_updated_by?(user)
  end
  
  def can_be_destroyed_by?(user)
    topic.can_be_updated_by?(user)
  end
  
  def can_be_sorted_by?(user)
    can_be_updated_by?(user)
  end
  
protected

  # def enough_content
  #   return if !url.blank?
  # end

end
