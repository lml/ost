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

And %r{instructor enrollment scenario setup} do
  FactoryGirl::create(:user, :first_name => "Admin",      :last_name => "Jones",    :username => "adminjones")
  FactoryGirl::create(:user, :first_name => "Professor",  :last_name => "X",        :username => "profx")
  FactoryGirl::create(:user, :first_name => "Professor",  :last_name => "Y",        :username => "profy")
  FactoryGirl::create(:user, :first_name => "Professor",  :last_name => "Z",        :username => "profz")

  get_smart = FactoryGirl.create(:organization, :name => "Get Smart")
  
  info =  [ { :course_name => "Intro 101: Only the Easy Stuff",
              :instructor_username => "profx",
              :section_info => [  { :name => "Section Alpha", :student_info => [ ] },
                                  { :name => "Section Beta",  :student_info => [ ] } ] 
            },
            { :course_name => "Course 102: Time to Rethink Your Major",
              :instructor_username => "profy",
              :section_info => [  { :name => "Section Alpha", :student_info => [ { :name => "Vito",     :status => :registered }, 
                                                                                 { :name => "Twila",    :status => :auditing   },
                                                                                 { :name => "Melissa",  :status => :dropped    } ] } 
                               ]
            },
            { :course_name => "Nightmare 666: You Will Fail",
              :instructor_username => "profz",
              :section_info => [  { :name => "Section Alpha", :student_info => [ { :name => "Dameon",   :status => :registered }, 
                                                                                 { :name => "Oda",      :status => :registered } ] },
                                  { :name => "Section Beta",  :student_info => [ { :name => "Adrien",   :status => :auditing   },
                                                                                 { :name => "Phoebe",   :status => :auditing   },
                                                                                 { :name => "Hubert",   :status => :dropped    } ] }
                               ]
            }
          ]

  info.each do |klass_info|
    course = FactoryGirl.create(:course, :name => klass_info[:course_name], :organization => get_smart)

    prof = User.find_by_username(klass_info[:instructor_username])

    FactoryGirl.create(:course_instructor, :user => prof, :course => course)

    klass = FactoryGirl.create(:klass, :course => course, :creator => prof)

    klass_info[:section_info].each_with_index do |section_info, idx|
      if idx == 0
        section = klass.sections.first
        section.name = section_info[:name]
        section.save!
      else
        section = FactoryGirl.create(:section, :klass => klass, :name => section_info[:name])
      end

      section_info[:student_info].each do |student_info|
        user = FactoryGirl.create(:user, :first_name => student_info[:name],
                                         :last_name  => Faker::Name.last_name,
                                         :username   => student_info[:name].downcase)
        is_auditing = (student_info[:status] == :auditing)
        student = FactoryGirl.create(:student, :user => user, :section => section, :is_auditing => is_auditing)
        if student_info[:status] == :dropped
          student.drop!
          student.save!
        end
      end
    end
  end
end

