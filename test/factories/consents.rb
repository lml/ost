# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :consent do
    consentable { Factory(:klass) }
    consent_form
    did_consent false
  end
end
