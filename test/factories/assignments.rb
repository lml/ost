# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :assignment do
    learning_plan_id 1
    name "MyString"
    is_test false
    is_open_book false
    is_group_work_allowed false
    is_ready false
    introduction "MyText"
    starts_at "2012-07-21 09:28:28"
    ends_at "2012-07-21 09:28:28"
  end
end
