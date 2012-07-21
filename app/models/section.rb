class Section < ActiveRecord::Base
  belongs_to :offered_course
  has_many :cohorts, :dependent => :destroy
  
  before_destroy :destroyable?
  
  validates :name, :presence => true, :uniqueness => {:scope => :offered_course_id}
  
  attr_accessible :name
  
protected

  def destroyable?
    raise NotYetImplemented
    false
  end

end
