class LearningPlan < ActiveRecord::Base
  belongs_to :learning_plannable, :polymorphic => true
  has_many :topics, :dependent => :destroy, :order => :number
  has_many :assignments, :dependent => :destroy
  has_many :concepts, :dependent => :destroy, :order => :number
  
  validates :learning_plannable_id, :presence => true
  validates :learning_plannable_type, :presence => true
  validates :name, :presence => true
  
  before_destroy :destroyable?
  
  attr_accessible :description, :name #:learning_plannable_id, :learning_plannable_type
  
  def destroyable?
    raise NotYetImplemented
  end
end
