class Resource < ActiveRecord::Base
  belongs_to :resourceable, :polymorphic => true
  
  validates :resourceable_id, :presence => true
  validates :resourceable_type, :presence => true
  validate :enough_content
  
  acts_as_numberable :container => :resourceable
  
  attr_accessible :name, :notes, :url
  
protected

  def enough_content
    return if !url.blank?
  end

end
