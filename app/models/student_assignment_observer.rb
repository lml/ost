# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class StudentAssignmentObserver < ActiveRecord::Observer
  
  def after_create(student_assignment)
    assignment = student_assignment.assignment
    if assignment.active?
      assignment.cohort.students.active.each do |student|
        AssignmentMailer.student_created(student, assignment).deliver
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
