# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class AssignmentMailer < SiteMailer
  helper :application

  def student_created(student, assignment)
    @assignment = assignment
    @student = student
    
    return if student.terp_only

    mail :to => "#{student.user.full_name} <#{student.user.email}>",
         :subject => "Assignment posted for #{full_class_name(@assignment)}"
  end
  
  def educator_created(assignment)
    @assignment = assignment
    klass = @assignment.cohort.klass

    return if klass.is_embedded

    educators = klass.educators
    mail(:to => educators.collect{|educator| "#{educator.user.full_name} <#{educator.user.email}>"},
         :subject => "Assignment posted for #{full_class_name(@assignment)}")
  end
end
