And %r{instructor teach course scenario setup} do
  FactoryGirl::create(:user, :first_name => "Admin",     :last_name => "Jones", :username => "adminjones")
  FactoryGirl::create(:user, :first_name => "Professor", :last_name => "X",     :username => "professor")
  FactoryGirl::create(:user, :first_name => "John",      :last_name => "Doe",   :username => "johndoe")
  
  get_smart = FactoryGirl.create(:organization, :name => "Get Smart")
  
  intro_101     = FactoryGirl.create(:course, :name => "Intro 101: Only the Easy Stuff",
                                              :organization => get_smart)

  nightmare_666 = FactoryGirl.create(:course, :name => "Nightmare 666: You Will Fail",
                                              :organization => get_smart)

  profX = User.find_by_username("professor")
  FactoryGirl.create(:course_instructor, :user => profX, :course => intro_101)
end


And %r{instructor dashboard scenario setup} do
  FactoryGirl::create(:user, :first_name => "Admin",     :last_name => "Jones", :username => "adminjones")
  FactoryGirl::create(:user, :first_name => "Professor", :last_name => "X",     :username => "profx")
  FactoryGirl::create(:user, :first_name => "Professor", :last_name => "Y",     :username => "profy")
  FactoryGirl::create(:user, :first_name => "Professor", :last_name => "Z",     :username => "profz")
  
  get_smart = FactoryGirl.create(:organization, :name => "Get Smart")
  
  intro_101     = FactoryGirl.create(:course, :name => "Intro 101: Only the Easy Stuff",
                                              :organization => get_smart)

  course_102    = FactoryGirl.create(:course, :name => "Course 102: Time to Rethink Your Major",
                                              :organization => get_smart)

  nightmare_666 = FactoryGirl.create(:course, :name => "Nightmare 666: You Will Fail",
                                              :organization => get_smart)

  profY = User.find_by_username("profy")
  FactoryGirl.create(:course_instructor, :user => profY, :course => intro_101)

  profZ = User.find_by_username("profz")
  FactoryGirl.create(:course_instructor, :user => profZ, :course => intro_101)
  FactoryGirl.create(:course_instructor, :user => profZ, :course => course_102)
  FactoryGirl.create(:course_instructor, :user => profZ, :course => nightmare_666)

  FactoryGirl.create(:klass, :course => intro_101,      :creator => profZ)
  FactoryGirl.create(:klass, :course => course_102,     :creator => profZ)
  FactoryGirl.create(:klass, :course => nightmare_666,  :creator => profZ)

  intro_101_klass = Klass.joins{ course }.where{ course.name == "Intro 101: Only the Easy Stuff" }.first
  FactoryGirl.create(:educator, :user => profY, :klass => intro_101_klass, :is_instructor => true)
end
