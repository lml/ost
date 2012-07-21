class Assignment < ActiveRecord::Base
  has_many :student_assignments, :dependent => :destroy
  has_many :assignment_topics, :dependent => :destroy
  has_many :topics, :through => :assignment_topics
  
  before_destroy :destroyable?
  
  attr_accessible :ends_at, :introduction, :is_group_work_allowed, :is_open_book, 
                  :is_ready, :is_test, :learning_plan_id, :name, :starts_at
  
  def destroyable?
    raise NotYetImplemented
  end
end
