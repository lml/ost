# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :klass do
    course
    start_date Time.now
    end_date Time.now + 3.months
    time_zone "Central Time (US & Canada)"
    association :creator, factory: :user
  end
end
