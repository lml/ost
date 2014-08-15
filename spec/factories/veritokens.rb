# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :veritoken do
    token "MyString"
    num_attempts_left 1
  end
end
