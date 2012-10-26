require 'db_dsl'
include DbDsl

module DbSetup

  def instructor_dashboard_setup
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

  def instructor_enrollment_setup
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

  def instructor_class_learning_plan_view_setup
    DbUniverse do

      DbCofUser first_name: "Admin",      last_name: "Jones", username: "admin"
      DbCofUser first_name: "Professor",  last_name: "X",     username: "profx"

      ex1 = DbCofExercise url: "http://google.com/search?q=michael+jordan"
      ex2 = DbCofExercise url: "http://google.com/search?q=spongebob+squarepants"

      DbCofOrganization name: "Get Smart" do

        DbCofCourse name: "Intro 101: Only the Easy Stuff" do
          DbCofInstructor for_user: { existing: "profx" } do
            DbCofClass()
          end
        end

        DbCofCourse name: "Course 102: Time to Rethink Your Major" do
          DbCofInstructor for_user: { existing: "profx" } do
            DbCofClass start_date: "Sep 1, 2010 5:00am", end_date: "Dec 1, 2010 5:00pm" do
              DbCofLearningPlan do
                con1 = DbCofConcept name: "Concept One"

                topic1 = DbCofTopic name: "First Topic"

                topic2 = DbCofTopic name: "Second Topic" do
                  DbCofResource name: "Resource One"
                  DbCofResource url: "http://www.google.com"
                  DbCofTopicExercise exercise: ex1, concept: con1
                  DbCofTopicExercise exercise: ex2, concept: con1
                end

                DbCofAssignmentPlan starts_at: "Sep 1, 2010 6:00am", ends_at: "Sep 5, 2010 10:00pm" do
                  DbCofAssignmentPlanTopic topic: topic1
                end
                DbCofAssignmentPlan starts_at: "Sep 3, 2010 6:00am", ends_at: "Sep 9, 2010 10:00pm" do
                  DbCofAssignmentPlanTopic topic: topic1
                  DbCofAssignmentPlanTopic topic: topic2
                end
              end
            end
          end
        end

      end

    end
  end

  def instructor_registration_request_setup
    DbUniverse do

      DbCofUser first_name: "Admin",      last_name: "Jones", username: "admin"
      DbCofUser first_name: "Professor",  last_name: "X",     username: "profx"

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
          DbCofInstructor for_user: { existing: "profx" } do
            DbCofClass do
              DbCofSection name: "Section Alpha" do
                DbCofRegistrationRequest for_user: {first_name: "Vito"}, is_auditing: false
              end
              DbCofSection name: "Section Beta" do
                DbCofRegistrationRequest for_user: {first_name: "Phoebe"}, is_auditing: true
                DbCofRegistrationRequest for_user: {first_name: "Hubert"}, is_auditing: false
              end
            end
          end
        end

        DbCofCourse name: "Nightmare 666: You Will Fail" do
          DbCofInstructor for_user: { existing: "profx" } do
            DbCofClass do
              DbCofSection name: "Section Alpha" do
                DbCofRegistrationRequest for_user: {first_name: "Dameon"}, is_auditing: false
                DbCofRegistrationRequest for_user: {first_name: "Oda"},    is_auditing: true
              end
            end
          end
        end
      
      end

    end
  end

  def instructor_teach_course_setup
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

end