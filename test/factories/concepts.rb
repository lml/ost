# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :concept do
    sequence(:name)  {|n| "Concept #{n}"}
    learning_plan
  end
end
