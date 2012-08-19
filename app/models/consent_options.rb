class ConsentOptions < ActiveRecord::Base
  belongs_to :consent_optionable, :polymorphic => true
  belongs_to :consent_form
  
  attr_accessible :closes_at, :consent_form_id, :opens_at, :enable_reask, :days_before_reask
  
  validates :consent_optionable_id, :presence => true
  validates :consent_optionable_type, :presence => true
  
  def ready_for_reask?(consent)
    consent.did_consent.nil? && 
    enable_reask && (Time.now - consent.created_at > days_before_reask.days)
  end
  
  def consenting_is_open?
    Time.now.between?(opens_at || consent_optionable.start_date, closes_at || consent_optionable.end_date)
  end
  
  #############################################################################
  # Access control methods
  #############################################################################

  def can_be_read_by?(user)
    user.is_researcher? || user.is_administrator?
  end
    
  def can_be_updated_by?(user)
    user.is_researcher? || user.is_administrator?
  end
  
end
