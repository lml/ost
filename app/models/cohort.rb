class Cohort < ActiveRecord::Base
  belongs_to :section
  has_many :students, :dependent => :destroy
  
  validates :section_id, :presence => :true

  before_destroy :destroyable?
  
  acts_as_numberable :container => :section
  
  attr_accessible
  
protected

  def destroyable?
    raise NotYetImplemented
  end
end
