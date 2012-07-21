class AssignmentMailer < SiteMailer
  helper :application

  def student_created(student, assignment)
    @assignment = assignment
    @student = student
    
    mail :to => "#{student.user.full_name} <#{student.user.email}>",
         :subject => "Assignment posted for #{full_section_name(@assignment.section)}"
  end
  
  def educator_created(assignment)
    @assignment = assignment

    educators = @assignment.section.educators
    mail(:to => educators.collect{|educator| "#{educator.user.full_name} <#{educator.user.email}>"},
         :subject => "Assignment posted for #{full_section_name(@assignment.section)}")
  end
end
