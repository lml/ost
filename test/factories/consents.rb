# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :consent do
    consentable_id 1
    consentable_type "MyString"
    esignature "MyString"
    consent_form_id 1
    did_consent false
  end
end
