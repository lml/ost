class StudentExerciseObserver < ActiveRecord::Observer
  
  def free_response_to_be_locked(student_exercise)
    ResponseTime.create(:response_timeable => student_exercise,
                        :event => "ACTIVITY",
                        :note => "free_response_locked",
                        :page => "work")
  end
  
  def selected_answer_to_be_locked(student_exercise)
    ResponseTime.create(:response_timeable => student_exercise,
                        :event => "ACTIVITY",
                        :note => "selected_answer_locked",
                        :page => "work")    
  end
  
  def updated(student_exercise)
    ResponseTime.create(:response_timeable => student_exercise,
                        :event => "ACTIVITY",
                        :note => "updated",
                        :page => "work")    
  end
  
  def after_save(student_exercise)
    if student_exercise.selected_answer_submitted?
      student_exercise.student_assignment.mark_complete_if_indicated!
    end
  end
end
