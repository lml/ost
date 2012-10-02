FactoryGirl.define do

  factory :course do
    name               { n = fg_unique_number ; "Course Gen #{n}" }
    description        Faker::Lorem::paragraphs(1).join
    typically_offered  "Fall Semester"
    organization
  end

end
