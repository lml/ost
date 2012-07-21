# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :learning_plan do
    learning_plannable_id 1
    learning_plannable_type "MyString"
    name "MyString"
    description "MyText"
  end
end
