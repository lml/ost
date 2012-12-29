class CorrectAssignmentExerciseContainerNumbers < ActiveRecord::Migration
  def up
    Assignment.find_each do |assignment|
      assignment.assignment_exercises.each_with_index do |ae,index|
        new_number = 1+index
        ae.number = new_number
      end

      assignment.assignment_exercises.reverse.each do |ae|
        ae.save!
      end
    end
  end

  def down
  end
end
