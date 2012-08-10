# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :scheduler do
    settings "MyText"
    learning_condition_id 1
    type ""
  end
end
