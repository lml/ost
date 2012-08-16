# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :exercise do
    url {"http://example.com/#{rand(2000000000000)}"}
    is_dynamic false
    content_cache "MyText"
  end
end
