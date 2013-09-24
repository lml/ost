class FixStudentExerciseConsistency < ActiveRecord::Migration

  class StudentExercise < ActiveRecord::Base
    belongs_to :student_assignment
    belongs_to :assignment_exercise
  end

  class StudentAssignment < ActiveRecord::Base
    belongs_to :assignment
  end

  class AssignmentExercise < ActiveRecord::Base
    belongs_to :assignment
  end

  def up
    ses = StudentExercise.joins{student_assignment}.joins{assignment_exercise}.where{~student_assignment.assignment_id != ~assignment_exercise.assignment_id}
    ses.each do |se|
      se.student_assignment.assignment = se.assignment_exercise.assignment
      se.student_assignment.save!
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
