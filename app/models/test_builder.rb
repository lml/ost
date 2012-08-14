
class TestBuilder
  
  # TODO instead of taking a cohort this could take a cohort or a study
  # result would still be an assignmnent, but if the assignment is for a study
  # it could have separate properties, different consent, etc
  def self.build_assignment(assignment_plan, cohort)
    raise IllegalOperation if !assignment_plan.is_test
    
    return Assignment.new(:cohort => cohort, :assignment_plan => assignment_plan)
  end
  
end