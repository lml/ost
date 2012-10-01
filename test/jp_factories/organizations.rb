# Read about factories at https://github.com/thoughtbot/factory_girl



FactoryGirl.define do
  factory :organization do
    name "Organization #{SecureRandom.random_number(1000000)}"
    default_time_zone "Central Time (US & Canada)"
  end
end
