# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :site_license do
    body Faker::Lorem::paragraphs(7).join("<p>")
    sequence(:title)  {|n| "Terms of Use (#{n})"}
  end
end
