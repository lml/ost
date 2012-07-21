# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :student_exercise do
    student_assignment_id 1
    assignment_exercise_id 1
    content_cache "MyText"
    free_response "MyText"
    free_response_submitted_at "2012-07-21 09:58:51"
    free_response_confidence 1
    selected_answer 1
    selected_answer_submitted_at "2012-07-21 09:58:51"
    was_submitted_late false
    automated_credit 1.5
    manual_credit 1.5
  end
end
