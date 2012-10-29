# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :consent_form do
    html                    "Autogen consent form text"
    esignature_required     false
    sequence(:name)         {|n| "AutoGen Consent Form #{n}"}
  end
end
