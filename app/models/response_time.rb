class ResponseTime < ActiveRecord::Base
  belongs_to :response_timeable, :polymorphic => true

  validates :event, :presence => true,
                    :inclusion => {:in => ["STARTED", "STOPPED", "HEARTBEAT", "ACTIVITY", "LINKCLICK", "TIMEOUT"]}
  validates :response_timeable_id, :presence => true
  validates :response_timeable_type, :presence => true

  before_save :clear_undefined_fields

  attr_accessible :event, :note, :page, :response_timeable_id, :response_timeable_type

  alias_attribute :timestamp, :created_at

  #############################################################################
  # Access control methods
  #############################################################################

  def can_be_created_by?(user)
    !response_timeable.nil? &&
    response_timeable.student.user_id == user.id
  end

protected

  def clear_undefined_fields
    self.note = nil if self.note == "undefined"
    self.page = nil if self.page == "undefined"
  end

end
