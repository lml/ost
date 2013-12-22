class StudentExternalAssignmentExercise < ActiveRecord::Base
  belongs_to :external_assignment_exercise
  belongs_to :student_external_assignment

  attr_accessible :external_assignment_exercise,
                  :student_external_assignment,
                  :grade
end
