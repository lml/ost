# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class AssignmentObserver < ActiveRecord::Observer
  
  def after_create(assignment)
    return if assignment.dry_run
        
    AssignmentMailer.educator_created(assignment).deliver
  end
  
end
