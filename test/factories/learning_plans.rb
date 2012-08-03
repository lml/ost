# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :learning_plan do
    learning_plannable_id 1
    learning_plannable_type "MyString"
    # learning_plannable FactoryGirl.create(:course)
    name "Learning Plan #{FactoryGirl.generate(:unique_number)}"
    description Faker::Lorem::paragraphs(1).join
  end
end
