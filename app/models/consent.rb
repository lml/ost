# A 'consentable' object must meet the following spec:
#
#   def is_consentable_for_user?(user) ... end
#     Returns true iff the object is consentable for the given user
# 
#   def not_currently_consentable? ... end 
#     Returns true if this object does not need consent based on its current state
#
#   def options_for_new_consent
#     Return the current consent options that should be used to consent this consentable
#
#   def name_for_consent
#     Returns a name for what's being consented


class Consent < ActiveRecord::Base
  belongs_to :consentable, :polymorphic => true
  belongs_to :consent_options

  validates :consentable_type, :presence => true
  validates :consentable_id, :presence => true, :uniqueness => {:scope => :consentable_type}
  validates :consent_options_id, :presence => true
  validates :esignature, :presence => {:if => Proc.new{|c| c.did_consent}}

  attr_protected :consent_options_id, :consentable_id, :consentable_type

  before_create :set_consent_form
  before_create :delete_old_consents

  def consented_at
    did_consent ? created_at : nil
  end
  
  def consent_set?
    !did_consent.nil?
  end

  def ready_for_reask?
    consent_options.ready_for_reask?(self)
  end

  #############################################################################
  # Access control methods
  #############################################################################

  def self.can_be_listed_by?(user)
    false
  end

  def can_be_read_by?(user)
    consentable.is_consentable_for_user?(user)
  end

  def can_be_created_by?(user)
    !user.is_anonymous? && 
    consentable.is_consentable_for_user?(user) &&
    consent_form.can_set_consent_now?
  end

  def can_be_updated_by?(user)
    false # consents cannot be updated.  they can only be destroyed and recreated
  end

  def can_be_destroyed_by?(user)
    raise NotYetImplemented
  end

protected

  def set_consent_options
    self.consent_options_id = consentable.options_for_new_consent.id
  end

  def delete_old_consents
    Consent.where(:consentable => consentable).destroy_all
  end
end
