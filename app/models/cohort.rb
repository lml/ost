class Cohort < ActiveRecord::Base
  belongs_to :section
  has_many :students, :dependent => :destroy

  before_destroy :destroyable?
  
  acts_as_numberable :container => :section
  
  attr_accessible
  
protected

  def destroyable?
    raise NotYetImplemented
    false
  end
end
