class AssignmentObserver < ActiveRecord::Observer
  
  def after_create(assignment)
    assignment.cohort.students.each do |student|
      AssignmentMailer.student_created(student, assignment).deliver
    end
    
    AssignmentMailer.educator_created(assignment).deliver
  end
  
end
