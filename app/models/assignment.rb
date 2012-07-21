class Assignment < ActiveRecord::Base
  belongs_to :learning_plan
  has_many :student_assignments, :dependent => :destroy
  has_many :assignment_topics, :dependent => :destroy
  has_many :topics, :through => :assignment_topics
  has_many :assignment_exercises, :dependent => :destroy
  
  before_destroy :destroyable?
  
  validates :name, :presence => true, :uniqueness => {:scope => :learning_plan_id}
  validates :starts_at, :presence => true
  validates :ends_at, :presence => true, :date => {:after => :starts_at}
  
  attr_accessible :ends_at, :introduction, :is_group_work_allowed, :is_open_book, 
                  :is_ready, :is_test, :learning_plan_id, :name, :starts_at
  
  scope :non_tests, where(:is_test => false)
  scope :tests, where(:is_test => true)
  
  def destroyable?
    raise NotYetImplemented
  end
  
end
