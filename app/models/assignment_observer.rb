# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class AssignmentObserver < ActiveRecord::Observer
  
  def after_create(assignment)
    return if assignment.dry_run
    
    assignment.cohort.students.active.each do |student|
      AssignmentMailer.student_created(student, assignment).deliver
    end
    
    AssignmentMailer.educator_created(assignment).deliver
  end
  
end
