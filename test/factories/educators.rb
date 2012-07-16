# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :educator do
    offered_course_id 1
    user_id 1
    is_instructor false
    is_teaching_assistant false
    is_grader false
  end
end
