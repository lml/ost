# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :scheduled_notification do
    user_id 1
    subject "MyString"
    message "MyText"
    send_after "2012-08-21 12:11:14"
  end
end
