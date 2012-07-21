class Educator < ActiveRecord::Base
  belongs_to :offered_course
  belongs_to :user
  
  validates :offered_course_id, :presence => true
  validates :user_id, :presence => true, :uniqueness => {:scope => :offered_course_id}
  
  attr_accessible :is_grader, :is_instructor, :is_teaching_assistant, :offered_course_id, :user_id
  
  
end
