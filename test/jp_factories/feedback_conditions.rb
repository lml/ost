# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :feedback_condition do
    learning_condition_id 1
    settings "MyText"
    type ""
    number 1
  end
end
