# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :topic_exercise do
    topic
    exercise
    concept 
  end
end
