class ConsentForm < ActiveRecord::Base
  has_many :consents 
  has_many :consent_options 

  attr_accessible :esignature_required, :html, :name
  
  validate :html_change_ok, :on => :update

  def used?
    consent_options.any?
  end
  
  #############################################################################
  # Access control methods
  #############################################################################

  def self.can_be_listed_by?(user)
    true
  end

  def can_be_read_by?(user)
    true
  end
    
  def can_be_created_by?(user)
    user.is_administrator? || user.is_researcher?
  end
  
  def can_be_updated_by?(user)
    user.is_administrator? || user.is_researcher?
  end
  
  def can_be_destroyed_by?(user)
    (user.is_administrator? || user.is_researcher?) && consents.none?{|c| !c.did_consent.nil?}
  end

protected
  
  def html_change_ok
    if html_changed? && consents.any?{|c| !c.did_consent.nil?}
      errors.add(:html, "cannot be changed because the form has active consents") 
    end      
    errors.none?
  end
  
end
