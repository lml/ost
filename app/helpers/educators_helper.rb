module EducatorsHelper
  def type(educator)
    return "instructor" if educator.is_instructor
    return "teaching_assistant" if educator.is_teaching_assistant
    return "grader" if educator.is_grader
  end
end