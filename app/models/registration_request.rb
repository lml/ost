# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class RegistrationRequest < ActiveRecord::Base
  belongs_to :section
  belongs_to :user
  
  validates :user_id, :presence => true
  validates :section_id, :presence => true, :uniqueness => {:scope => :user_id}
  validate :user_not_already_in_course
  validate :user_without_pending_requests_for_this_course
  validate :researcher_not_registering
  
  after_create :approve_if_preapproved
  
  attr_accessor :destroyed
  after_destroy :mark_as_destroyed
  
  attr_accessible :is_auditing, :student_specified_id, :section_id, :user_id
  
  attr_accessor :approved
  
  ## TODO THIS CLASS HAS A LOT OF COPIED CODE AND NEEDS WORK! ##
  
  def approve!
    Student.create(:user_id => user_id, :section_id => section_id, 
                   :is_auditing => is_auditing, :student_specified_id => student_specified_id)
    notify_observers(:approved)
    self.approved = true # for automatic approvals
    self.destroy
  end
  
  def reject!
    notify_observers(:rejected)
    self.destroy
  end
  
  def requestor_full_name
    student_specified_id.blank? ? user.full_name : "Student #{student_specified_id}"
  end
  
  def requestor_email
    student_specified_id.blank? ? user.email : "[private]"
  end
  
  #############################################################################
  # Access control methods
  #############################################################################

  def can_be_read_by?(user)
    user.id == user_id || klass.is_teacher?(user)
  end
    
  def can_be_created_by?(user)
    user.id == user_id && !klass.is_embedded
  end
  
  def can_be_approved_by?(user)
    klass.is_teacher?(user)
  end
  
  def can_be_rejected_by?(user)
    klass.is_teacher?(user)
  end
  
  def can_be_destroyed_by?(user)
    user.id == user_id || klass.is_teacher?(user)
  end
  
protected

  def klass
    section.klass
  end

  def user_not_already_in_course
    errors.add(:base, "You are already a student in this class.") \
      if user.students.any?{|s| s.section.klass_id == section.klass_id}
    errors.empty?
  end
  
  def user_without_pending_requests_for_this_course
    errors.add(:base, "You have already requested to join another section in this class.") \
      if user.registration_requests.any?{|rr| rr.section.klass_id == section.klass_id}
    errors.empty?
  end

  def researcher_not_registering
    errors.add(:base, 'You cannot register for this class because you are a system researcher.') \
      if !is_auditing && Researcher.is_one?(user)
    errors.empty?
  end
  
  def approve_if_preapproved
    approve! if !is_auditing && 
                klass.is_preapproved?(user) && 
                (!klass.ended? || !Rails.env.production?)
  end
  
  def mark_as_destroyed
    self.destroyed = true
  end

end