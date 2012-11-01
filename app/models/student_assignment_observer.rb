# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

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
