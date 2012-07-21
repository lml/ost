class RegistrationRequest < ActiveRecord::Base
  belongs_to :section
  belongs_to :user
  
  validates :user_id, :presence => true
  validates :section_id, :presence => true, :uniqueness => {:scope => :user_id}
  
  before_destroy :destroyable?
  
  attr_accessible :is_auditing #, :section_id, :user_id
  
  def destroyable?
    raise NotYetImplemented
  end
end
