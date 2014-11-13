# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class StudentAssignmentObserver < ActiveRecord::Observer
  
  def after_create(student_assignment)
    assignment = student_assignment.assignment
    if assignment.active?
      if student_assignment.student.terp_only
        CaMailer.ca_created(student_assignment.student, assignment).deliver
      else
        AssignmentMailer.student_created(student_assignment.student, assignment)
                        .deliver
      end
    end
  end

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
