# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :percent_scheduler do
    settings "MyText"
    learning_condition_id 1
  end
end