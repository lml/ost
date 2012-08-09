# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :exercise do
    sequence(:url)  {|n| "http://example.com/#{n}"}
    is_dynamic false
    content_cache "MyText"
  end
end
