class StudentAssignmentObserver < ActiveRecord::Observer
  
  def due(student_assignment)
    student_assignment.learning_condition
                      .notify_student_assignment_event(student_assignment, 
                                                       StudentAssignment::Event::DUE)
  end
  
  def complete(student_assignment)
    student_assignment.learning_condition
                      .notify_student_assignment_event(student_assignment, 
                                                       StudentAssignment::Event::COMPLETE)
  end
  
end
