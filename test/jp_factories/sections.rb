# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :section do
    klass
    name "Section #{Faker::Lorem.words(2).join(' ')}"
  end
end
