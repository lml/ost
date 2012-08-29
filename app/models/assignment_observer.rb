class AssignmentObserver < ActiveRecord::Observer
  
  def after_create(assignment)
    return if assignment.dry_run
    
    assignment.cohort.students.active.each do |student|
      AssignmentMailer.student_created(student, assignment).deliver
    end
    
    AssignmentMailer.educator_created(assignment).deliver
  end
  
end
