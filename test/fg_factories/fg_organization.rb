FactoryGirl.define do
  
  factory :organization do
    name              { n = fg_unique_number ; "Organization Gen #{n}" }
    default_time_zone "Central Time (US & Canada)"  
  end
  
end