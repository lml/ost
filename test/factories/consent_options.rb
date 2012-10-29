# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :consent_option, :class => 'ConsentOptions' do
    consent_form
    association :consent_optionable, factory: :klass
    opens_at       { Time.now }
    closes_at      { Time.now + 3.months }
  end
end
