# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :consent_option, :class => 'ConsentOptions' do
    consent_form_id 1
    consent_optionable_id 1
    consent_optionable_type "MyString"
    opens_at "2012-08-15 12:04:55"
    closes_at "2012-08-15 12:04:55"
  end
end
