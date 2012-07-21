class AssignmentTopic < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :topic
  
  validate :assignment_id, :presence => true
  validate :topic_id, :presence => true, :uniqueness => {:scope => :assignment_id}
  
  attr_accessible
end
