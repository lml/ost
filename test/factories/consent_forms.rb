# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :consent_form do
    html "MyText"
    esignature_required false
    name "MyString"
  end
end
