class ConsentForm < ActiveRecord::Base
  has_many :consent_options, :class_name => 'ConsentOptions'
  
  attr_accessible :esignature_required, :html, :name
  
  validate :html_change_ok, :on => :update

  def used?
    consent_options.empty?
  end
  
  def any_consents?
    used? && consent_options.any?{|co| co.consents.any?{|c| c.consent_set?}}
  end
  
  #############################################################################
  # Access control methods
  #############################################################################

  def self.can_be_listed_by?(user)
    user.is_researcher? || user.is_administrator?
  end

  def can_be_read_by?(user)
    true
  end
    
  def can_be_created_by?(user)
    user.is_administrator? || user.is_researcher?
  end
  
  def can_be_updated_by?(user)
    user.is_administrator? || user.is_researcher? && !any_consents?
  end
  
  def can_be_destroyed_by?(user)
    (user.is_administrator? || user.is_researcher?) && !any_consents?
  end

protected
  
  def html_change_ok
    if html_changed? && consents.any?{|c| !c.did_consent.nil?}
      errors.add(:html, "cannot be changed because the form has active consents") 
    end      
    errors.none?
  end
  
end
