# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :registration_request do
    user
    section
    is_auditing false
  end
end
