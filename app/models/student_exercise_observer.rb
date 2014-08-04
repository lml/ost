# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

class StudentExerciseObserver < ActiveRecord::Observer
  
  def free_response_to_be_locked(student_exercise)
    ResponseTime.create(:response_timeable => student_exercise,
                        :event => "ACTIVITY",
                        :note => "free_response_locked",
                        :page => "work")
    student_exercise.student_assignment.mark_started_if_indicated!
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
  
  def answer_selected(student_exercise)
    student_exercise.student_assignment.mark_complete_if_indicated!
    student_exercise.learning_condition
                    .notify_student_exercise_event(student_exercise, 
                                                   StudentExercise::Event::COMPLETE)    
  end
  
  def feedback_viewed(student_exercise)
    student_exercise.learning_condition
                    .notify_student_exercise_event(student_exercise, 
                                                   StudentExercise::Event::FEEDBACK_VIEWED)    
  end
  
end
