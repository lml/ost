# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cohort do
    klass
    sequence(:name)  {|n| "AutoGen Cohort #{n}"}
  end
end
