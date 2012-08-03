class Topic < ActiveRecord::Base
  belongs_to :learning_plan
  has_many :topic_exercises, :dependent => :destroy, :order => :number
  has_many :assignment_topics, :dependent => :destroy
  has_many :assignments, :through => :assignment_topics
  has_many :resources, :order => :number
  
  before_destroy :destroyable?  
  
  validates :learning_plan_id, :presence => true
  validates :name, :presence => true, :uniqueness => {:scope => :learning_plan_id}
  
  acts_as_numberable :container => :learning_plan
  
  attr_accessible :name, :learning_plan_id
  
  before_validation :set_default_name, :on => :create
  
  def destroyable?
    raise NotYetImplemented
  end
  
  #############################################################################
  # Access control methods
  #############################################################################

  def can_be_read_by?(user)
    learning_plan.can_be_read_by?(user)
  end

  def can_be_created_by?(user)
    learning_plan.can_be_updated_by?(user)
  end

  def can_be_updated_by?(user)
    learning_plan.can_be_updated_by?(user)
  end

  def can_be_destroyed_by?(user)
    learning_plan.can_be_updated_by?(user)
  end
  
protected

  def set_default_name
    return unless name.blank?
    
    existing_topics = learning_plan.topics
    existing_names = existing_topics.collect{|t| t.name}
    topic_number = existing_topics.count + 1

    while (existing_names.include?(self.name = "New Topic #{topic_number}"))
      topic_number += 1
    end
  end
  
end
