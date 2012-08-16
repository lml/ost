
module Ost
  module Utilities

    def full_class_name(object)
      
      case object.class.name
      when "Section"
        object.klass.course.name
      when "Assignment"
        object.cohort.klass.course.name
      when "StudentExercise"
        object.student_assignment.student.section.klass.course.name
      end
      
    end

  end
end
