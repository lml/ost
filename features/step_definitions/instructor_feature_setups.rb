
And %r{instructor teach course scenario setup} do
  DbUniverse do
    DbCofUser first_name: "Admin",      last_name: "Jones", username: "admin"
    DbCofUser first_name: "Professor",  last_name: "X",     username: "profx"
    DbCofUser first_name: "John",       last_name: "Doe",   username: "johndoe"

    DbCofOrganization name: "Get Smart" do
      DbCofCourse name: "Intro 101: Only the Easy Stuff" do
        DbCofInstructor for_user: { existing: "profx" }
      end
      DbCofCourse name: "Nightmare 666: You Will Fail"
    end
  end
end


And %r{instructor dashboard scenario setup} do
  DbUniverse do

    DbCofUser first_name: "Admin",      last_name: "Jones", username: "admin"
    DbCofUser first_name: "Professor",  last_name: "X",     username: "profx"
    DbCofUser first_name: "Professor",  last_name: "Y",     username: "profy"
    DbCofUser first_name: "Professor",  last_name: "Z",     username: "profz"

    DbCofOrganization name: "Get Smart" do

      DbCofCourse name: "Intro 101: Only the Easy Stuff" do
        DbCofInstructor for_user: { existing: "profz" } do
          DbCofClass do
            DbCofEducator for_user: { existing: "profy" }, is_instructor: true
          end
        end
      end

      DbCofCourse name: "Course 102: Time to Rethink Your Major" do
        DbCofInstructor for_user: { existing: "profz" } do
          DbCofClass()
        end
      end

      DbCofCourse name: "Nightmare 666: You Will Fail" do
        DbCofInstructor for_user: { existing: "profz" } do
          DbCofClass() 
        end
      end
    
    end

  end
end

And %r{instructor enrollment scenario setup} do
  DbUniverse do

    DbCofUser first_name: "Admin",      last_name: "Jones", username: "admin"
    DbCofUser first_name: "Professor",  last_name: "X",     username: "profx"
    DbCofUser first_name: "Professor",  last_name: "Y",     username: "profy"
    DbCofUser first_name: "Professor",  last_name: "Z",     username: "profz"

    DbCofOrganization name: "Get Smart" do

      DbCofCourse name: "Intro 101: Only the Easy Stuff" do
        DbCofInstructor for_user: { existing: "profx" } do
          DbCofClass do
            DbCofSection name: "Section Alpha"
            DbCofSection name: "Section Beta"
          end
        end
      end

      DbCofCourse name: "Course 102: Time to Rethink Your Major" do
        DbCofInstructor for_user: { existing: "profy" } do
          DbCofClass do
            DbCofSection name: "Section Alpha" do
              DbCofStudent for_user: {first_name: "Vito"},    status: :registered
              DbCofStudent for_user: {first_name: "Twila"},   status: :auditing
              DbCofStudent for_user: {first_name: "Melissa"}, status: :dropped
            end
          end
        end
      end

      DbCofCourse name: "Nightmare 666: You Will Fail" do
        DbCofInstructor for_user: { existing: "profz" } do
          DbCofClass do
            DbCofSection name: "Section Alpha" do
              DbCofStudent for_user: {first_name: "Dameon"},    status: :registered
              DbCofStudent for_user: {first_name: "Oda"},       status: :registered
            end
            DbCofSection name: "Section Beta" do
              DbCofStudent for_user: {first_name: "Adrien"},    status: :auditing
              DbCofStudent for_user: {first_name: "Phoebe"},    status: :auditing
              DbCofStudent for_user: {first_name: "Hubert"},    status: :dropped
            end
          end
        end
      end
    
    end

  end
end

