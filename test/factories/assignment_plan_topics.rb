# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :assignment_plan_topic do
    assignment_plan
    topic
  end
end
