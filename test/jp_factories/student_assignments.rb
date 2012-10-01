# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :student_assignment do
    student
    assignment
  end
end
