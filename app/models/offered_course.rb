class OfferedCourse < ActiveRecord::Base
  belongs_to :course
  belongs_to :consent_form
    
  validates :start_date, :presence => true

  before_destroy :destroyable?
  
  attr_accessible :course_id, :start_date
  
protected

  def destroyable?
    raise NotYetImplemented
    false
  end

end
