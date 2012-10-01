FactoryGirl.define do

  factory :educator do
    klass
    user
    is_instructor         false
    is_teaching_assistant false
    is_grader             false
  end

end
