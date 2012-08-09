# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :learning_plan do
    learning_plannable_id 1
    learning_plannable_type "MyString"
    # learning_plannable FactoryGirl.create(:course)
    sequence(:name)  {|n| "Learning Plan #{n}"}
    description Faker::Lorem::paragraphs(1).join
  end
end
