# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :learning_plan do
    klass
    sequence(:name)     {|n| "Learning Plan #{n}"}
    description         Faker::Lorem::paragraphs(1).join
  end
end
