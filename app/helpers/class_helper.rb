# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

module ClassHelper
  def report_coworkers(student_assignment, user=present_user)
    students = student_assignment.assignment_coworkers.collect{|acw| acw.student}.concat([student_assignment.student])
    student_names = students.collect do |student|
      if user.is_researcher?
        student.consented? ? student.full_name(user) : "non-consenting student"
      else
        student.full_name(user)
      end
    end
    student_names.sort_by{|name| name.downcase}.join(',')
  end
end
