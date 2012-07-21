class RegistrationRequest < ActiveRecord::Base
  belongs_to :section
  belongs_to :user
  
  validates :user_id, :presence => true
  validates :section_id, :presence => true, :uniqueness => {:scope => :user_id}
  validate :user_not_already_in_course
  validate :researcher_not_registering
  
  after_create :approve_if_preapproved
  
  attr_accessor :destroyed
  after_destroy :mark_as_destroyed
  
  attr_accessible :is_auditing #, :section_id, :user_id
  
  attr_accessor :approved
  
  ## TODO THIS CLASS HAS A LOT OF COPIED CODE AND NEEDS WORK! ##
  
  def approve!
    section.register!(user, is_auditing)
    notify_observers(:approved)
    # self.approved = true # this doesn't appear to do anything, but leaving temporarily
    self.destroy
  end
  
  def reject!
    notify_observers(:rejected)
    self.destroy
  end
  
  #############################################################################
  # Access control methods
  #############################################################################

  def can_be_read_by?(user)
    user.id == user_id || offered_course.is_educator?(user)
  end
    
  def can_be_created_by?(user)
    user.id == user_id
  end
  
  def can_be_approved_by?(user)
    offered_course.is_educator?(user)
  end
  
  def can_be_rejected_by?(user)
    offered_course.is_educator?(user)
  end
  
  def can_be_destroyed_by?(user)
    user.id == user_id || offered_course.is_educator?(user)
  end
  
protected

  def offered_course
    section.offered_course
  end

  def user_not_already_in_course
    errors.add(:base, "You are already a student in this course.") \
      if user.students.any?{|s| s.cohort.section.offered_course_id == section.offered_course_id}
    errors.empty?
  end

  def researcher_not_registering
    errors.add(:base, 'You cannot register for this class because you are a system researcher.') \
      if !is_auditing && Researcher.is_one?(user)
    errors.empty?
  end
  
  def approve_if_preapproved
    approve! if !auditing && 
                offered_course.is_preapproved?(user) && 
                (!offered_course.ended? || !Rails.env.production?)
  end
  
  def mark_as_destroyed
    self.destroyed = true
  end

end