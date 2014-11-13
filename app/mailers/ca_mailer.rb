# Copyright 2011-2014 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class CaMailer < TerpMailer
  helper :application

  def ca_created(student, assignment)
    @assignment = assignment
    @student = student
    
    return unless student.terp_only && @assignment.assignment_plan.is_test

    mail :to => "#{student.user.full_name} <#{student.user.email}>",
         :subject => "Practice test released for #{full_class_name(@assignment)}"
  end
end
