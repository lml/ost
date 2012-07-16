# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :offered_course do
    course_id 1
    approved_emails "MyText"
    consent_form_id 1
    start_date "2012-07-16 14:21:35"
  end
end
