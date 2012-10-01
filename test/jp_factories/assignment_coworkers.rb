# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :assignment_coworker do
    student_assignment
    student
  end
end
