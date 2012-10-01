FactoryGirl.define do
  
  factory :user do
    first_name            { Faker::Name::first_name }
    last_name             { fg_unique_last_name }
    username              { |u| fg_unique_username(u.first_name, u.last_name) }
    email                 { |u| "#{u.username}@example.com" }
    is_administrator      false
    password              { fg_password }
    password_confirmation { |u| "#{u.password}" }
    confirmed_at          { Time.now }
    
    factory :admin do
      is_administrator true
    end    
  end
  
end