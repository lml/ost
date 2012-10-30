# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :assignment_plan do
    learning_plan
    sequence(:name)         {|n| "HW #{n}"}
    is_test                 false
    is_open_book            false
    is_group_work_allowed   false
    is_ready                false
    introduction            Faker::Lorem::paragraphs(2).join("\n")
    starts_at               { learning_plan ? learning_plan.klass.start_date : Time.now }
    ends_at                 { starts_at + 15.minutes }
  end
end
