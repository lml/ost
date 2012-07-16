# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :student do
    cohort_id 1
    user_id 1
    is_auditing false
  end
end
