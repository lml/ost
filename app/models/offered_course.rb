class OfferedCourse < ActiveRecord::Base
  belongs_to :course
  belongs_to :consent_form
  has_one :learning_plan, :as => :learning_plannable, :dependent => :destroy
  has_many :sections, :dependent => :destroy
  has_many :educators, :dependent => :destroy
    
  validates :start_date, :presence => true
  validates :course_id, :presence => true

  before_destroy :destroyable?
  
  attr_accessible :start_date, :approved_emails, :time_zone
  
  def is_preapproved?(user)
    approved_emails_array = (approved_emails || '').split("\n").collect{|ae| ae.strip}
    
    approved_emails_array.any? do |ae|
      user.email.downcase == ae.downcase || 
      user.email.downcase.match(ae.downcase)
    end
  end
  
  def is_educator?(user)
    educators.any?{|e| e.user_id == user.id}
  end
  
  #############################################################################
  # Access control methods
  #############################################################################
  
  def can_be_read_by?(user)
    true
  end
    
  def can_be_created_by?(user)
    course.is_instructor?(user) || user.is_administrator?
  end
  
  def can_be_updated_by?(user)
    is_educator?(user) || user.is_administrator?
  end
  
  def can_be_destroyed_by?(user)
    is_educator?(user) || user.is_administrator?
  end
  
protected

  def destroyable?
    return true if sections.empty? || sudo_enabled?
    errors.add(:base, "This offered course cannot be deleted because it has sections.")
    false
  end

end
