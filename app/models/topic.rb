class Topic < ActiveRecord::Base
  belongs_to :learning_plan
  has_many :topic_exercises, :dependent => :destroy, :order => :number
  has_many :assignment_topics, :dependent => :destroy
  has_many :assignments, :through => :assignment_topics
  has_many :resources, :as => :resourceable, :order => :number
  
  before_destroy :destroyable?  
  
  validates :learning_plan_id, :presence => true
  validates :name, :presence => true, :uniqueness => {:scope => :learning_plan_id}
  
  acts_as_numberable :container => :learning_plan
  
  attr_accessible :name
  
  def destroyable?
    raise NotYetImplemented
  end
end
