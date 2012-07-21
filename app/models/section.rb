class Section < ActiveRecord::Base
  belongs_to :offered_course
  has_many :cohorts, :dependent => :destroy, :order => :number
  has_many :registration_requests, :dependent => :destroy
  
  before_destroy :destroyable?
  
  validates :offered_course_id, :presence => true
  validates :name, :presence => true, :uniqueness => {:scope => :offered_course_id}
  
  attr_accessible :name
  
protected

  def destroyable?
    raise NotYetImplemented
    false
  end

end
