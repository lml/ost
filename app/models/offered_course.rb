class OfferedCourse < ActiveRecord::Base
  belongs_to :course
  belongs_to :consent_form
  has_one :learning_plan, :as => :learning_plannable, :dependent => :destroy
  has_many :sections, :dependent => :destroy
    
  validates :start_date, :presence => true
  validates :course_id, :presence => true

  before_destroy :destroyable?
  
  attr_accessible :start_date
  
  def is_preapproved?(user)
    approved_emails_array = (approved_emails || '').split("\n").collect{|ae| ae.strip}
    
    approved_emails_array.any? do |ae|
      user.email.downcase == ae.downcase || 
      user.email.downcase.match(ae.downcase)
    end
  end
  
  
protected

  def destroyable?
    # Probably not deletable unless SUDO override or so sections yet
    raise NotYetImplemented
    false
  end

end
