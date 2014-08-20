# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class Section < ActiveRecord::Base
  belongs_to :klass
  has_many :cohorts, :dependent => :nullify
  has_many :students, :dependent => :destroy
  has_many :registration_requests, :dependent => :destroy
  
  before_destroy :destroyable?, prepend: true
  
  validates :klass_id, :presence => true
  validates :name, :presence => true, :uniqueness => {:scope => :klass_id}
  validates :registration_code, :uniqueness => {:allow_blank => true}
  
  attr_accessible :name, :klass, :registration_code
  
  before_validation :nil_blank_registration_code
  after_create :populate_registration_code

  def nil_blank_registration_code
    self.registration_code = nil if registration_code.blank?
  end

  def populate_registration_code
    return if registration_code.present?
    reset_registration_code!
  end

  def reset_registration_code!
    new_code = Babbler.babble until Section.where(registration_code: new_code).none?
    self.update_attribute(:registration_code, new_code)
  end

  #############################################################################
  # Access control methods
  #############################################################################

  def can_be_read_by?(user)
    !user.is_anonymous?
  end
    
  def can_be_created_by?(user)
    !user.is_anonymous? && (klass.is_instructor?(user) || user.is_administrator?)
  end
  
  def can_be_updated_by?(user)
    !user.is_anonymous? && (klass.is_instructor?(user) || user.is_administrator?)
  end
  
  def can_be_destroyed_by?(user)
    !user.is_anonymous? && (klass.is_instructor?(user) || user.is_administrator?)
  end
  
  def children_can_be_read_by?(user, children_symbol)
    case children_symbol
    when :students
      !user.is_anonymous? && (klass.is_educator?(user) || Researcher.is_one?(user) || user.is_administrator?)
    else
      false
    end
  end
  
protected

  def destroyable?
    self.errors.add(:base, "This section cannot be deleted because it is the last one in its course offering") \
      if klass.sections(true).count == 1
    
    self.errors.add(:base, "This section cannot be deleted because students are assigned to it.") \
      if students(true).any?
        
    self.errors.add(:base, "This section cannot be deleted because it has active cohorts.") \
      if cohorts(true).any?

    return errors.empty?
  end

end
