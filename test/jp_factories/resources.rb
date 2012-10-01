# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :resource do
    topic
    sequence(:url)  {|n| "http://example.com/#{n}"}
    notes "MyText aslkdfj lkafdj lkadjf klajdflk ajdflkaj sdflkaj dlfkjasdlkfj"
  end
end
