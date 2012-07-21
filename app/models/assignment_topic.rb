class AssignmentTopic < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :topic
  
  validates :assignment_id, :presence => true
  validates :topic_id, :presence => true, :uniqueness => {:scope => :assignment_id}
  
  attr_accessible
end
