# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :course do
    name "MATH 101: #{Faker::Lorem.words(2).join(' ')}"
    description Faker::Lorem::paragraphs(1).join
    typically_offered "Fall Semester"
    organization
  end
end
