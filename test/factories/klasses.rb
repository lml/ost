# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :klass do
    course
    start_date "Jul 9, 2012 9:00 AM"
    end_date "Dec 15, 2012 1:00 PM"
    time_zone "Central Time (US & Canada)"
  end
end
