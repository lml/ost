# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :response_time do
    response_timeable_id 1
    response_timeable_type "MyString"
    event "MyString"
    note "MyString"
    page "MyString"
  end
end
