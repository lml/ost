class StudentExternalAssignment < ActiveRecord::Base
  belongs_to :external_assignment
  belongs_to :student

  has_many :student_external_assignment_exercises

  attr_accessible :external_assignment, :student, :student_external_assignment_exercises
end
