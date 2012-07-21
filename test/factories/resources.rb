# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :resource do
    resourceable_type "MyString"
    resourceable_id 1
    url "MyString"
    name "MyString"
    notes "MyText"
    number 1
  end
end
