# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    first_name              {Faker::Name::first_name + FactoryGirl.generate(:unique_number).to_s}
    last_name               {Faker::Name::last_name}
    username                {|u| unique_username(u.first_name, u.last_name)}
    email                   {|u| "#{u.username}@example.com"}
    is_administrator        false
    password                "password"
    password_confirmation   "password"
    confirmed_at            {Time.now}
  end
end
