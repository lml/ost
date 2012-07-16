# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :registration_request do
    user_id 1
    section_id 1
    is_auditing false
  end
end
