# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :student do
    section
    cohort
    user
    is_auditing false
  end
end
