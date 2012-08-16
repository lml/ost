# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :assignment_exercise do
    assignment
    topic_exercise
  end
end
