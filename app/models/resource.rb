class Resource < ActiveRecord::Base
  belongs_to :resourceable, :polymorphic => true
  
  validate :enough_content
  
  acts_as_numberable :container => :resourceable
  
  attr_accessible :name, :notes, :url
  
protected

  def enough_content
    return if !url.blank?
  end

end
